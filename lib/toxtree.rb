require 'csv'
require 'tempfile'

class Toxtree
  RULES = {
    "Cramer rules" => {
      :java_class => "toxTree.tree.cramer.CramerRules",
      :url => "http://toxtree.sourceforge.net/cramer.html"
    },
    "Cramer rules with extensions" => {
      :java_class => "cramer2.CramerRulesWithExtensions",
      :url => ""
    },
    "Verhaar scheme" => {
      :java_class => "verhaar.VerhaarScheme",
    },
    "Modified Verhaar scheme" => {
      :java_class => "toxtree.plugins.verhaar2.VerhaarScheme2",
    },
    "Skin irritation" => {
      :java_class => "sicret.SicretRules",
    },
    "Eye irritation" => {
      :java_class => "eye.EyeIrritationRules",
    },
    "START biodegradation and persistence" => {
      :java_class => "com.molecularnetworks.start.BiodgeradationRules",
    },
    "Benigni / Bossa rulebase for mutagenicity and carcinogenicity" => {
      :java_class => "mutant.BB_CarcMutRules",
    },
    "In vitro mutagenicity (Ames test) alerts by ISS" => {
      :java_class => "toxtree.plugins.ames.AmesMutagenicityRules",
    },
    "Structure Alerts for the in vivo micronucleus assay in rodents (ISSMIC)" => {
      :java_class => "mic.MICRules",
    },
    "Structural Alerts for Functional Group Identification (ISSFUNC)" => {
      :java_class => "toxtree.plugins.func.FuncRules",
    },
    "Structure Alerts for identification of Michael Acceptors" => {
      :java_class => "michaelacceptors.MichaelAcceptorRules",
    },
    "Structure Alerts for skin sensitisation reactivity domains" => {
      :java_class => "toxtree.plugins.skinsensitisation.SkinSensitisationPlugin",
    },
    "DNA binding alerts" => {
      :java_class => "toxtree.plugins.dnabinding.DNABindingPlugin",
    },
    "Protein binding alerts" => {
      :java_class => "toxtree.plugins.proteinbinding.ProteinBindingPlugin",
    },
    "Kroes TTC Decision tree" => {
      :java_class => "toxtree.plugins.kroes.Kroes1Tree",
    },
    "SMARTCyp - Cytochrome P450-Mediated Drug Metabolism and metabolites prediction" => {
      :java_class => "toxtree.plugins.smartcyp.SMARTCYPPlugin",
    },

  }

  def self.predict smiles, rules="Cramer rules"
    smiles = [smiles] unless smiles.is_a? Array
    rules = [rules] unless rules.is_a? Array
    predictions = []
    input = Tempfile.new(["input",".csv"])
    output = input.path.sub("input","result")
    begin
      input.write "SMILES\n"
      input.write smiles.join("\n")
      input.close
      rules.each do |name|
        `cd #{File.join(File.dirname(__FILE__),"..","Toxtree-v2.6.13","Toxtree")}; java -jar Toxtree-2.6.13.jar -i #{input.path} -m #{RULES[name][:java_class]} -n -o #{output}`
        prediction = CSV.read(output)
        unless prediction.empty?
          header = prediction.shift
          header.pop # remove last empty element
          smiles.each do |smi|
            line = prediction.flatten.include?(smi) ? prediction.find{|array| array[0 ]== smi} : ["nil","nil","nil","nil"]
            p = {"rule" => name}
            header.each_with_index do |h,i|
              p[h] = line[i]
            end
            predictions << p
          end
        else
          smiles.each do |smi|
            p = {"rule" => name}
            p["SMILES"] = smi
            p[name] = nil
            predictions << p
          end
        end
      end
    ensure
      input.unlink
    end
    predictions.size == 1 ? predictions[0] : predictions
  end

end
