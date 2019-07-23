require_relative 'api-client'

module TestrailRSpec
  class UpdateTestRails
    attr_accessor :client

    def initialize(scenario)
      @scenario = scenario

      if File.exist? './testrail_config.yml'
        @config = YAML.load_file("./testrail_config.yml")['testrail']
        raise 'TestRail configuration file not loaded successfully' if @config.nil?
      else
        raise 'TestRail configuration file is required'
      end

      setup_testrail_client
    end

    def upload_result

      response = {}
      case_id = @scenario.metadata[:description].split(' ').first.scan(/\d+/).first rescue nil

      status_id = get_status_id 'passed'.to_sym if @scenario.exception == nil
      status_id = get_status_id 'failed'.to_sym if @scenario.exception != nil
      run_id = @config['run_id']

      if case_id && run_id
        response = client.send_post(
            "add_result_for_case/#{run_id}/#{case_id}",
            { status_id: status_id }
        )
      else
        raise 'unable to get case id or run id'
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
  end
end
