/*
  �������� 
    - ������� PlanMobileApp (������������ ���������� ����� �� ����������)
    - ������
    - ��������
*/


-- DROP TABLE ImplementationPlan;

/*-------------------------------------------------------------------------------*/
CREATE TABLE ImplementationPlan
(
  UserId           Integer,
  UnitId           Integer,  
  PenaltiMobApp    TFloat,
  AntiTOPMP_Place  Integer,
  
  Total            TFloat,

  CONSTRAINT pk_ImplementationPlan PRIMARY KEY (UserId)
);

ALTER TABLE ImplementationPlan
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/


/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.   ������� �.�.   ������ �.�.
22.06.2023                                                        *
*/