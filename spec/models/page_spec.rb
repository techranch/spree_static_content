require File.dirname(__FILE__) + '/../spec_helper'

describe Spree::Page do
  before(:each) do
    @page = Spree::Page.create(
    :title => 'test page',
    :slug => 'test-page',
    :body => 'this is a test page'
    )
  end

  it "should be valid" do
    @page.should be_valid
  end

  it "should add an / to the slug" do
    @page.slug.should == "/test-page"
  end

  context "with parent page" do
    before do
      @parent_page = Spree::Page.create(
        :title => 'test page',
        :slug => 'parent-page',
        :body => 'this is a test page'
      )
      @page.parent = @parent_page
      @page.save
    end

    it "should add parent name to slug if one exists" do
      @page.slug.should eql ('/parent-page/test-page')
    end

    context "with grandparent page" do
      before do
        @grandparent_page = Spree::Page.create(
          :title => 'test page',
          :slug => 'grandparent-page',
          :body => 'this is a test page'
        )
        @parent_page.parent = @grandparent_page
        @parent_page.save
        @page.save
      end

      it "should add all parent pages to slug if one exists" do
        @page.slug.should eql ('/grandparent-page/parent-page/test-page')
      end
    end
  end
end
