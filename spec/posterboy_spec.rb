require "spec_helper"

describe Posterboy do

  describe ".search" do

    let!(:user) do
      User.create(first_name: "Syd", last_name: "Vicious")
    end

    context "when performing an AND search" do

      context "when provided a single term" do

        context "when the term is a stem" do

          context "when the term matches" do

            let(:results) do
              User.search(:and, "Syd")
            end

            it "returns the matching results" do
              results.should == [ user ]
            end
          end

          context "when the term does not match" do

          end
        end

        context "when the word is a variation of a stem" do

        end
      end
    end
  end

  describe ".search_on" do

    context "when provided a list of symbols" do

      before do
        User.search_on :first_name, :last_name
      end

      let(:searchables) do
        User.send(:searchables)
      end

      it "adds the symbols to the searchables" do
        searchables.should == [ :first_name, :last_name ]
      end
    end

    context "when provided a list with a hash" do

      before do
        User.search_on tags: :name
      end

      let(:searchables) do
        User.send(:searchables)
      end

      it "adds the hash to the searchables" do
        searchables.should == [ { tags: :name } ]
      end
    end

    context "when provided a mix of symbols and hashes" do

      before do
        User.search_on :first_name, :last_name, tags: :name
      end

      let(:searchables) do
        User.send(:searchables)
      end

      it "adds the mixed elements to the searchables" do
        searchables.should == [ :first_name, :last_name, { tags: :name } ]
      end
    end
  end
end
