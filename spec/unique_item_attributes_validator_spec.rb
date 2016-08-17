require "spec_helper"

class Hero
  include ActiveModel::Validations
  attr_accessor :alter_ego, :name, :superpower

  def initialize(alter_ego:, name:, superpower:)
    @alter_ego = alter_ego
    @name = name
    @superpower = superpower
  end
end

class SuperTeam
  include ActiveModel::Validations
  attr_accessor :heroes

  validates :heroes, unique_item_attributes: [:alter_ego, :name]

  def initialize(heroes:)
    @heroes = heroes
  end
end

ATTRIBUTES_TO_BE_CHECKED = [:alter_ego, :name].freeze
ATTRIBUTES_TO_NOT_BE_CHECKED = [:superpower].freeze

describe UniqueItemAttributesValidator do
  it "has a version number" do
    expect(UniqueItemAttributesValidator::VERSION).not_to be nil
  end

  it "validates only enumerables" do
    expect { SuperTeam.new(heroes: "").valid? }.to raise_error ArgumentError
  end

  context "with items with no duplication" do
    let(:heroes_with_no_duplication) do
      [
        Hero.new(alter_ego: "Bruce Trevor", name: "Eagleman", superpower: "super-strength"),
        Hero.new(alter_ego: "Steve Wayne", name: "Superbat", superpower: "super-strength")
      ]
    end
    let(:model) { SuperTeam.new(heroes: heroes_with_no_duplication) }

    it "passes the validation" do
      expect(model.valid?).to be_truthy
    end

    before { model.valid? }

    it "does not mark any items as error" do
      model.heroes.each do |hero|
        (ATTRIBUTES_TO_BE_CHECKED + ATTRIBUTES_TO_NOT_BE_CHECKED).each do |attrs|
          expect(hero.errors[attrs]).to be_empty
        end
      end
    end
  end

  context "with items containing duplication" do
    let(:heroes_with_duplication) do
      [
        Hero.new(alter_ego: "Bruce Trevor", name: "Eagleman", superpower: "super-strength"),
        Hero.new(alter_ego: "Bruce Trevor", name: "Eagleman", superpower: "super-strength")
      ]
    end
    let(:model) { SuperTeam.new(heroes: heroes_with_duplication) }

    context "that are declared to be checked" do
      it "does not passes the validation" do
        expect(model.valid?).to be_falsey
      end

      before { model.valid? }

      it "is marked as error with the message: `messages.model_invalid`" do
        expect(model.errors[:base]).to include I18n.t("messages.model_invalid")
      end

      it "does not mark the original item as error" do
        original_item = model.heroes[0]
        ATTRIBUTES_TO_BE_CHECKED.each do |attrs|
          expect(original_item.errors[attrs]).to be_empty
        end
      end

      it "marks the duplicated item as taken with the message: `errors.messages.taken`" do
        item_with_duplicated_attributes = model.heroes[1]
        ATTRIBUTES_TO_BE_CHECKED.each do |attrs|
          expect(item_with_duplicated_attributes.errors[attrs]).to include I18n.t("errors.messages.taken")
        end
      end
    end

    context "that are not declared to be checked" do
      it "does not mark item as error, even if it's duplicated" do
        model.heroes.each do |hero|
          ATTRIBUTES_TO_NOT_BE_CHECKED.each do |attrs|
            expect(hero.errors[attrs]).to be_empty
          end
        end
      end
    end
  end

  context "with items marked for destruction" do
    let(:hero_marked_for_destruction) { Hero.new(alter_ego: "Bruce Trevor", name: "Eagleman", superpower: "fly") }
    let(:hero) { Hero.new(alter_ego: "Bruce Trevor", name: "Eagleman", superpower: "super-strength") }
    let(:heroes_with_duplication) { [hero_marked_for_destruction, hero] }
    let(:model) { SuperTeam.new(heroes: heroes_with_duplication) }

    it "ignores the items marked for destruction" do
      expect(hero_marked_for_destruction).to receive(:respond_to?).with(:marked_for_destruction?).and_return true
      expect(model.heroes).to receive(:reject).and_return [hero]
      expect(model.valid?).to be_truthy
    end
  end
end
