/*
  �������� 
    - ������� ChildReportContainerLink (��������� �������� "�������� ��� ������")
    - �����
    - ��������
*/

/*-------------------------------------------------------------------------------*/
CREATE TABLE ChildReportContainerLink(
   Id                     SERIAL NOT NULL, 
   ChildReportContainerId Integer NOT NULL,
   ContainerId            Integer NOT NULL,
   AccountId              Integer NOT NULL,
   AccountKindId          Integer NOT NULL,

   CONSTRAINT pk_ChildReportContainerLink               PRIMARY KEY (ContainerId, ChildReportContainerId, AccountKindId),
   CONSTRAINT fk_ChildReportContainerLink_ContainerId   FOREIGN KEY (ContainerId) REFERENCES Container (Id),
   CONSTRAINT fk_ChildReportContainerLink_AccountId     FOREIGN KEY (AccountId) REFERENCES Object (Id),
   CONSTRAINT fk_ChildReportContainerLink_AccountKindId FOREIGN KEY (AccountKindId) REFERENCES Object (Id)
);

/*-------------------------------------------------------------------------------*/
/*                                  �������                                      */
-- CREATE INDEX idx_ChildReportContainerLink_ChildReportContainerId ON ChildReportContainerLink (ChildReportContainerId);
-- CREATE INDEX idx_ChildReportContainerLink_AccountId_AccountKindId ON ChildReportContainerLink (AccountId, AccountKindId);

CREATE INDEX idx_ChildReportContainerLink_ContainerId_AccountKindId_ChildReportContainerId  ON ChildReportContainerLink (ContainerId, AccountKindId, ChildReportContainerId);
CREATE INDEX idx_ChildReportContainerLink_ChildReportContainerId_ContainerId_AccountKindId  ON ChildReportContainerLink (ChildReportContainerId, ContainerId, AccountKindId);
CREATE INDEX idx_ChildReportContainerLink_AccountId  ON ChildReportContainerLink (AccountId); -- ����������
CREATE INDEX idx_ChildReportContainerLink_AccountKindId  ON ChildReportContainerLink (AccountKindId); -- ����������
CREATE INDEX idx_ChildReportContainerLink_MasterkeyValue_ChildkeyValue ON ChildReportContainerLink (MasterkeyValue,ChildkeyValue); -- ����������

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
10.05.15                                         *
19.09.02                                         * chage index
03.09.13                                         *
*/
