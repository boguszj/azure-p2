public with sharing class SallaryPredictorController {

	@AuraEnabled
	public static List<Map<String,String>> getSkills () {
		List<Map<String,String>> allSkillsPicklist = new List<Map<String, String>>();
		for (Skill__c skill : [SELECT Name FROM Skill__c ORDER BY Name ASC]) {
			allSkillsPicklist.add(
				new Map<String, String>{
					'label' => skill.Name,
					'value' => skill.Name
				}
			);
		}
		return allSkillsPicklist;
	}

	@AuraEnabled
	public static String getPrediction (List<Map<String,Object>> skills, String advancementLevel) {

		skills.add(new Map<String,Object>{'advancementLevel' => advancementLevel});
		HttpRequest req = new HttpRequest();
		req.setEndpoint('callout:salaryPredictor');
		req.setBody(JSON.serialize(skills));
		req.setMethod('POST');

		HTTPResponse res = new Http().send(req);
		String avgSalary = res.getBody();
		return avgSalary;
	}

}