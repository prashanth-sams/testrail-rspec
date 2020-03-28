require_relative 'api-client'

module TestrailRSpec
  class UpdateTestRails
    attr_accessor :client

    def initialize(scenario)
      @scenario = scenario

      if File.exist? './testrail_config.yml'
        @config = YAML.load_file("./testrail_config.yml")['testrail']

        @config = @config.transform_values do |e|
          if e.class != Integer && e.to_s.include?('ENV[')
            eval(e)
          else
            e
          end
        end
        raise 'TestRail configuration file not loaded successfully' if @config.nil?
      else
        raise 'TestRail configuration file is required'
      end

      return if [@config['allow'].nil?, @config['allow']].all? false
      setup_testrail_client
      config_validator if $config_validator.nil?
    end

    def upload_result
      return if [@config['allow'].nil?, @config['allow']].all? false
      response = {}

      case_list = []
      @scenario.full_description.split(' ').map do |e|
        val = e.scan(/\d+/).first
        next if val.nil?
        case_list << val
      end

      return if case_list.empty?

      if (@scenario.exception) && (!@scenario.exception.message.include? 'pending')
        status_id = get_status_id 'failed'.to_sym
        message = @scenario.exception.message
      elsif @scenario.skipped?
        status_id = get_status_id 'blocked'.to_sym
        message = "This test scenario is skipped from test execution"
      elsif @scenario.pending?
        status_id = get_status_id 'blocked'.to_sym
        message = "This test scenario is pending for test execution"
      else
        status_id = get_status_id 'passed'.to_sym
        message = "This test scenario was automated and passed successfully"
      end

      @run_id ||= @config['run_id']
      @run_id = @@run_id rescue @@run_id = nil unless @config['run_id']
      @run_id = @@run_id = client.create_test_run("add_run/#{@config['project_id']}", {"suite_id": @config['suite_id']}) if @run_id.nil?

      case_list.map do |case_id|
        response = client.send_post("add_result_for_case/#{@run_id}/#{case_id}",{ status_id: status_id })
        warn("\n###################### \ninvalid #case_id: #{case_id} \n######################") if (response.nil? || response['error'] != nil) && (response.class != Integer)
      end

      response
    end

    def fetch_status_ids
      client.send_get('get_statuses')
    end

    private

    def setup_testrail_client
      @client = TestRail::APIClient.new(@config['url'])
      @client.user = @config['user']
      @client.password = @config['password']
    end

    def config_validator
      config_hash = {:project_id => @config['project_id'], :suite_id => @config['suite_id'], :run_id => @config['run_id']}
      config_hash.map do |key, value|
        next if value.nil?
        check_avail(key, value)
      end

      cleaner if [@config['project_id'], @config['clean_testrun'], @config['run_id'].nil?].all?
      $config_validator = true
    end

    def get_status_id(status)
      case status
      when :passed
        1
      when :blocked
        2
      when :untested
        3
      when :retest
        4
      when :failed
        5
      when :undefined
        raise 'missing step definition'
      else
        raise 'unexpected scenario status passed'
      end
    end

    def cleaner
      test_run_list = client.send_get("get_runs/#{@config['project_id']}")
      test_run_list.map do |list|
        next if !@config['skip_testrun_ids'].nil? && @config['skip_testrun_ids'].to_s.delete(' ').split(',').any?(list['id'].to_s)
        client.send_post("delete_run/#{list['id']}", {"suite_id": @config['suite_id']})
      end
    end

    def check_avail(label, id)
      case label
      when :project_id
        warn("\n###################### \ninvalid #project_id: #{id} \n######################") if client.send_get("get_project/#{id}").nil? || client.send_get("get_project/#{id}")['error'] != nil
      when :suite_id
        warn("\n###################### \ninvalid #suite_id: #{id} \n######################") if client.send_get("get_suite/#{id}").nil? || client.send_get("get_suite/#{id}")['error'] != nil
      when :run_id
        warn("\n###################### \ninvalid #run_id: #{id} \n######################") if client.send_get("get_run/#{id}").nil? || client.send_get("get_run/#{id}")['error'] != nil
      else
        p "no config available"
      end
    end
  end
end
