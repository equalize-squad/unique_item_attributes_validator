require "active_model/validations"

module ActiveModel
  module Validations
    class UniqueItemAttributesValidator < ActiveModel::EachValidator
      def validate_each(record, _attribute, value)
        raise ArgumentError, ":#{value} must be an enumerable" unless value.is_a? Enumerable
        collection = remove_items_marked_for_destruction(value)
        options[:in].each { |item_attribute| validate_unique_item_attribute(record, collection, item_attribute) }
      end

      private

      def validate_unique_item_attribute(record, collection, attribute)
        collect_duplication(collection, attribute).tap do |duplicated|
          duplicated.each do |item|
            item.errors[attribute] << I18n.t("errors.messages.taken")
          end
          record.errors[:base] << I18n.t("messages.model_invalid") if duplicated.any?
        end
      end

      def collect_duplication(collection, attribute)
        collection.group_by { |item| item.send(attribute) }.
          select { |_key, values| values.size > 1 }.
          flat_map { |_key, values| values.slice(1, values.size) }
      end

      def remove_items_marked_for_destruction(collection)
        if collection.any? { |obj| obj.respond_to?(:marked_for_destruction?) }
          collection.reject(&:marked_for_destruction?)
        else
          collection
        end
      end
    end
  end
end
