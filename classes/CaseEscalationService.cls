public with sharing class CaseEscalationService {

    /**
     * Marks open, high priority Cases as escalated.
     * @param caseIds Ids of the Cases to evaluate
     * @return number of Cases escalated
     */
    public static Integer escalateHighPriorityCases(Set<Id> caseIds) {
        if (caseIds == null || caseIds.isEmpty()) {
            return 0;
        }

        List<Case> toUpdate = new List<Case>();
        for (Case c : [
            SELECT Id, Priority, IsEscalated, IsClosed
            FROM Case
            WHERE Id IN :caseIds
            AND Priority = 'High'
            AND IsEscalated = false
            AND IsClosed = false
        ]) {
            c.IsEscalated = true;
            toUpdate.add(c);
        }

        if (!toUpdate.isEmpty()) {
            update toUpdate;
        }
        return toUpdate.size();
    }
}