require 'json'
require 'minitest/autorun'
require_relative '../lib/toxtree.rb'

class ToxtreeTest < MiniTest::Test
  def test_cramer
    skip
    assert_equal Toxtree.predict("c1ccccc1NN"), {:smiles=>"c1ccccc1NN", :prediction=>"High (Class III)", :rule=>"Cramer rules"}
  end
  def test_all_rules
    smiles = ["c1ccccc1NN","c1ccccc1N","CCC(CC)CC#N"]
    Toxtree::RULES.each do |name,rule|
      puts JSON.pretty_generate(Toxtree.predict(smiles,name))
    end
  end
  def test_urls
    skip
  end
end

