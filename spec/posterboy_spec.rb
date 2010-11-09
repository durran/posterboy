require "spec_helper"

describe Posterboy do

  before(:all) do
    User.delete_all
    User.create(
      first_name: "Syd",
      last_name: "Vicious",
      instrument: "flute"
    )
  end

  describe ".search" do

    context "when performing an AND search" do

      context "when provided a single term" do

        context "when the term is a stem" do

          context "when the term matches" do

            let(:results) do
              User.search(:and, "Syd")
            end

            it "returns the correct number of results" do
              results.count.should == 1
            end

            it "returns the correct results" do
              results.first.first_name.should == "Syd"
            end
          end

          context "when the term does not match" do

            let(:results) do
              User.search(:and, "Nancy")
            end

            it "returns empty results" do
              results.should be_empty
            end
          end
        end

        context "when the word is a variation of a stem" do

          context "when the term matches" do

            let(:results) do
              User.search(:and, "flutes")
            end

            it "returns the correct number of matching results" do
              results.count.should == 1
            end

            it "returns the correct matching results" do
              results.first.first_name.should == "Syd"
            end
          end

          context "when the term does not match" do

            let(:results) do
              User.search(:and, "flutenotaword")
            end

            it "returns the matching results" do
              results.should be_empty
            end
          end
        end
      end

      context "when provided multiple terms" do

        context "when the terms are stems" do

          context "when the terms match" do

            let(:results) do
              User.search(:and, "Syd Vicious")
            end

            it "returns the correct matching results" do
              results.first.first_name.should == "Syd"
            end

            it "returns the correct number of results" do
              results.count.should == 1
            end
          end

          context "when the term does not match" do

            let(:results) do
              User.search(:and, "Johnny Rotten")
            end

            it "returns empty results" do
              results.should be_empty
            end
          end
        end

        context "when the words are variations of a stem" do

          context "when the terms match" do

            let(:results) do
              User.search(:and, "flute")
            end

            it "returns the matching results" do
              results.first.first_name.should == "Syd"
            end

            it "returns the correct number of results" do
              results.count.should == 1
            end
          end

          context "when the terms do not match" do

            let(:results) do
              User.search(:and, "bassnotaword bassthis")
            end

            it "returns the matching results" do
              results.should be_empty
            end
          end
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
