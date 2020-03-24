shared_examples 'pass' do
  it 'pass' do
    expect(true).to be true
  end
end

shared_examples 'fail' do
  it 'fail' do
    expect(false).to be true
  end
end

describe 'Generic scenarios' do
  context 'A regular user can' do
    context 'C845' do
      include_examples 'pass'
    end

    context 'C847' do
      include_examples 'fail'
    end
  end

  context 'Complex scenarios' do
    context 'C850 C853 multi cases' do
      include_examples 'pass'
    end

    context 'Not going to update in test-rail' do
      include_examples 'fail'
    end
  end
end