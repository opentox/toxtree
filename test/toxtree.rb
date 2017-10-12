require 'minitest/autorun'
require_relative '../lib/toxtree.rb'

class ToxtreeTest < MiniTest::Test

  def test_cramer
    assert_equal Toxtree.predict("c1ccccc1NN"), {"rule"=>"Cramer rules", "SMILES"=>"c1ccccc1NN", "CRAMERFLAGS"=>nil, "Cramer rules"=>"High (Class III)", "toxTree.tree.cramer.CramerTreeResult"=>"1N,2N,3N,5N,6N,7N,16N,17N,19N,23Y,27Y,28N,30Y,31N,32N,22N,33N"}
  end

  def test_all_rules
    smiles = ["c1ccccc1NN","c1ccccc1N","CCC(CC)CC#N"]
    Toxtree::RULES.each do |name,rule|
      Toxtree.predict(smiles,name).each do |prediction|
        refute_nil prediction
        assert_equal name, prediction["rule"]
        assert smiles.include?(prediction["SMILES"])
      end
    end
  end

  def test_urls
    skip
  end

  def test_no_prediction
    assert_equal Toxtree.predict("O=S(=O)(Oc1ccccc1)CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCS(=O)(=O)Oc1ccccc1"), {"rule"=>"Cramer rules", "SMILES"=>"O=S(=O)(Oc1ccccc1)CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCS(=O)(=O)Oc1ccccc1", "Cramer rules"=>nil}
  end

  def test_no_prediction_array
    assert_equal Toxtree.predict(["O=S(=O)(Oc1ccccc1)CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCS(=O)(=O)Oc1ccccc1","O=S(=O)(Oc1ccccc1)CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCS(=O)(=O)Oc1ccccc1"]), [{"rule"=>"Cramer rules", "SMILES"=>"O=S(=O)(Oc1ccccc1)CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCS(=O)(=O)Oc1ccccc1", "Cramer rules"=>nil}, {"rule"=>"Cramer rules", "SMILES"=>"O=S(=O)(Oc1ccccc1)CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCS(=O)(=O)Oc1ccccc1", "Cramer rules"=>nil}]
  end

  def test_with_and_without_prediction_array
    predictions = Toxtree.predict(["c1ccccc1NN","O=S(=O)(Oc1ccccc1)CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCS(=O)(=O)Oc1ccccc1"])
    assert_equal predictions.size, 2
    assert_equal predictions, [{"rule"=>"Cramer rules", "SMILES"=>"c1ccccc1NN", "CRAMERFLAGS"=>nil, "Cramer rules"=>"High (Class III)", "toxTree.tree.cramer.CramerTreeResult"=>"1N,2N,3N,5N,6N,7N,16N,17N,19N,23Y,27Y,28N,30Y,31N,32N,22N,33N"}, {"rule"=>"Cramer rules", "SMILES"=>"nil", "CRAMERFLAGS"=>"nil", "Cramer rules"=>"nil", "toxTree.tree.cramer.CramerTreeResult"=>"nil"}]
  end

end

