RSpec.shared_context "view_object" do
  class ViewObject
    attr_accessor :output_buffer
    include ActionView::Helpers::TagHelper
    include SemanticNavigation::HelperMethods
    include ActionView::Helpers::UrlHelper
  end

  let(:view_object) { ViewObject.new }
end
