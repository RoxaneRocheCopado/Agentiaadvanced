@IsTest
private class CaseEscalationServiceTest {

    @TestSetup
    static void setup() {
        insert new List<Case>{
            new Case(Subject = 'High case', Priority = 'High', Origin = 'Web'),
            new Case(Subject = 'Low case', Priority = 'Low', Origin = 'Web')
        };
    }

    @IsTest
    static void escalatesOnlyHighPriorityCases() {
        Map<Id, Case> cases = new Map<Id, Case>([SELECT Id FROM Case]);

        Test.startTest();
        Integer count = CaseEscalationService.escalateHighPriorityCases(cases.keySet());
        Test.stopTest();

        System.assertEquals(1, count, 'Only the high priority case should be escalated');
        System.assertEquals(1, [SELECT COUNT() FROM Case WHERE IsEscalated = true AND Priority = 'High']);
        System.assertEquals(0, [SELECT COUNT() FROM Case WHERE IsEscalated = true AND Priority = 'Low']);
    }

    @IsTest
    static void alreadyEscalatedCasesAreSkipped() {
        Map<Id, Case> cases = new Map<Id, Case>([SELECT Id FROM Case]);
        CaseEscalationService.escalateHighPriorityCases(cases.keySet());

        Integer secondRun = CaseEscalationService.escalateHighPriorityCases(cases.keySet());

        System.assertEquals(0, secondRun, 'Nothing left to escalate');
    }

    @IsTest
    static void nullOrEmptyInputReturnsZero() {
        System.assertEquals(0, CaseEscalationService.escalateHighPriorityCases(null));
        System.assertEquals(0, CaseEscalationService.escalateHighPriorityCases(new Set<Id>()));
    }
}