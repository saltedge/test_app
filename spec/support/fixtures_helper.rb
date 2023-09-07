module FixturesHelper
  def load_fixture(path)
    File.read(Rails.root.to_s + "/spec/fixtures/test/#{path}")
  end
end