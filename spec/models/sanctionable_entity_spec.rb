describe SanctionableEntity do
  let!(:sanctionable_entity) { create :sanctionable_entity }

  it { should validate_presence_of(:list_name) }
  it { should validate_presence_of(:official_id) }
  it { should validate_presence_of(:extra) }

  
  describe "validations" do
    it "should allow country_id to be nil" do
      sanctionable_entity = build :sanctionable_entity, gender: nil
      expect(sanctionable_entity.valid?).to be true
    end
    it "should allow country_id to be nil" do
      sanctionable_entity = build :sanctionable_entity, additional_info: nil
      expect(sanctionable_entity.valid?).to be true
    end
  end
end
