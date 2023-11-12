/**
 * * This class tests the PreventDuplicateOpportunities trigger. The PreventDuplicateOpportunities trigger prevents duplicate opportunities from being inserted by comparing their descriptions (which should have unique urls)
 */
@isTest
public class TestPreventDuplicateOpportunities {
  @TestSetup
  static void setup() {
    // Create 200 sample accts w/ opp
    List<Account> sampleAccts = TestDataFactory.createAccountsWithOpps(200, 1);
    List<Opportunity> updatedOpps = new List<Opportunity>();
    for (Account acc : sampleAccts) {
      for (Opportunity opp : acc.Opportunities) {
        opp.Description = 'testing';
        updatedOpps.add(opp);
      }
    }
    update updatedOpps;
  }
  @isTest
  static void test() {
    // create and attempt to insert duplicate opps. opps with the same desc. are classified as duplicates
    Test.startTest();
    List<Opportunity> newOpps = TestDataFactory.createOpps(10);
    for (Opportunity opp : newOpps) {
      opp.Description = 'testing';
    }
    try {
      insert newOpps;
      // The above insert should throw a DmlException
    } catch (DmlException e) {
      // Verify that the error message indicates a duplicate error
      System.assertEquals(true, e.getMessage().contains('Duplicate(s) error'));
    }
    Test.stopTest();
  }
}
