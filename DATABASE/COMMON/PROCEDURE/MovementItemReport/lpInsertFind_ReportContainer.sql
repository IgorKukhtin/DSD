-- Function: lpInsertFind_ReportContainer (Integer, Integer, Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertFind_ReportContainer (Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_ReportContainer(
    IN inActiveContainerId   Integer              , -- 
    IN inPassiveContainerId  Integer              , -- 
    IN inActiveAccountId     Integer              , -- 
    IN inPassiveAccountId    Integer                -- 
)
  RETURNS Integer AS
$BODY$
  DECLARE vbReportContainerId Integer;
BEGIN

     -- ��������
     IF  COALESCE (inActiveContainerId, 0) = 0 OR COALESCE (inPassiveContainerId, 0) = 0
      OR COALESCE (inActiveAccountId, 0) = 0 OR COALESCE (inPassiveAccountId, 0) = 0
     THEN
         RAISE EXCEPTION '���������� c����������� ��������� � �������� ��� ������ � ������ ������ : "%", "%", "%", "%"', inActiveContainerId, inPassiveContainerId, inActiveAccountId, inPassiveAccountId;
     END IF;

     -- �������
     vbReportContainerId:=(SELECT ReportContainerLink_Active.ReportContainerId
                           FROM ReportContainerLink  AS ReportContainerLink_Active
                                JOIN ReportContainerLink  AS ReportContainerLink_Passive
                                                          ON ReportContainerLink_Passive.ReportContainerId = ReportContainerLink_Active.ReportContainerId
                                                         AND ReportContainerLink_Passive.ContainerId = inPassiveContainerId
                                                         AND ReportContainerLink_Passive.AccountKindId = zc_Enum_AccountKind_Passive()
                           WHERE ReportContainerLink_Active.ContainerId = inActiveContainerId
                             AND ReportContainerLink_Active.AccountKindId = zc_Enum_AccountKind_Active()
                          );

     -- ���� �� �����, ���������
     IF COALESCE (vbReportContainerId, 0) = 0
     THEN
         -- ���������� ����� ReportContainerId
         SELECT NEXTVAL ('reportcontainer_id_seq') INTO vbReportContainerId;

         -- �������� ���������
         INSERT INTO ReportContainerLink (ReportContainerId, ContainerId, AccountId, AccountKindId)
            SELECT vbReportContainerId, inActiveContainerId, inActiveAccountId, zc_Enum_AccountKind_Active()
           UNION ALL
            SELECT vbReportContainerId, inPassiveContainerId, inPassiveAccountId, zc_Enum_AccountKind_Passive()
            ;

     END IF;  

     -- ���������� ��������
     RETURN (vbReportContainerId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertFind_ReportContainer (Integer, Integer, Integer, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.09.13                                        * optimize
 29.08.13                                        *
*/

-- ����
/*
SELECT * FROM lpInsertFind_ReportContainer (inActiveContainerId   := 1
                                          , inPassiveContainerId  := 2
                                          , inActiveAccountId     := 11
                                          , inPassiveAccountId    := 12
                                           )
*/
