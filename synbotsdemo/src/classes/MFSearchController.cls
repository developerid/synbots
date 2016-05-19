public with sharing class MFSearchController {

  // the soql without the order and limit
  private String soql {get;set;}
  // the collection of contacts to display
  public List<KrishLightning__Account_Setup_Automation_c__x> contacts {get;set;}

  // the current sort direction. defaults to asc
  public String sortDir {
    get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
    set;
  }

  // the current field to sort by. defaults to last name
  public String sortField {
    get  { if (sortField == null) {sortField = 'KrishLightning__First_Name_SO1_c__c'; } return sortField;  }
    set;
  }

  // format the soql for display on the visualforce page
  public String debugSoql {
    get { return soql + ' order by ' + sortField + ' ' + sortDir + ' limit 20'; }
    set;
  }

  // init the controller and display some sample data when the page loads
  public MFSearchController() {
    soql = 'select  KrishLightning__First_Name_SO1_c__c, KrishLightning__Estimated_Annual_Volume_D_c__c,    KrishLightning__Business_Legal_Name_BP_c__c, KrishLightning__Contact_Name_BP_c__c from KrishLightning__Account_Setup_Automation_c__x where KrishLightning__Business_Legal_Name_BP_c__c != null';
    runQuery();
  }

  // toggles the sorting of query from asc<-->desc
  public void toggleSort() {
    // simply toggle the direction
    sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
    // run the query again
    runQuery();
  }

  // runs the actual query
  public void runQuery() {

    try {
      contacts = Database.query(soql + ' order by ' + sortField + ' ' + sortDir + ' limit 20');
      system.debug('Sort results.......'+contacts);
    } catch (Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'));
    }

  }

  // runs the search with parameters passed via Javascript
  public PageReference runSearch() {

    String FN= Apexpages.currentPage().getParameters().get('firstname');
    String EAV= Apexpages.currentPage().getParameters().get('KrishLightning__Estimated_Annual_Volume_D_c__c');
    String AN= Apexpages.currentPage().getParameters().get('accountName');
    //String technology = Apexpages.currentPage().getParameters().get('technology');

    soql = 'select KrishLightning__First_Name_SO1_c__c, KrishLightning__Estimated_Annual_Volume_D_c__c, KrishLightning__Business_Legal_Name_BP_c__c,    KrishLightning__Contact_Name_BP_c__c from KrishLightning__Account_Setup_Automation_c__x where KrishLightning__Business_Legal_Name_BP_c__c != null';
    if (!FN.equals(''))
      soql += ' and KrishLightning__First_Name_SO1_c__c LIKE \''+String.escapeSingleQuotes(FN)+'%\'';
    if (!EAV.equals(''))
      soql += ' and KrishLightning__Estimated_Annual_Volume_D_c__c LIKE \''+String.escapeSingleQuotes(EAV)+'%\'';
    if (!AN.equals(''))
      soql += ' and KrishLightning__Business_Legal_Name_BP_c__c LIKE \''+String.escapeSingleQuotes(AN)+'%\'';
      
     
   /* if (!technology.equals(''))
      soql += ' and interested_technologies__c includes (\''+technology+'\')';*/

    // run the query again
    runQuery();

    return null;
  }

  // use apex describe to build the picklist values
 /* public List<String> technologies {
    get {
      if (technologies == null) {

        technologies = new List<String>();
        Schema.DescribeFieldResult field = Contact.interested_technologies__c.getDescribe();

        for (Schema.PicklistEntry f : field.getPicklistValues())
          technologies.add(f.getLabel());

      }
      return technologies;          
    }
    set;
  }*/

}