/*
  �������� 
    - ������� MovementSiteBonus (������ �� ���������� ����������)
    - ������
    - ��������
*/


-- DROP TABLE MovementSiteBonus;

/*-------------------------------------------------------------------------------*/
CREATE TABLE MovementSiteBonus
(
  MovementId        Integer,  -- �����
  BuyerForSiteCode  Integer,  -- ���������� ����� "�� �����"
  Bonus             TFloat,   -- ��������� �������
  Bonus_Used        TFloat,   -- ������������ �������

  CONSTRAINT pk_MovementSiteBonus PRIMARY KEY (MovementId)
);

ALTER TABLE MovementSiteBonus
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/


/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.   ������� �.�.   ������ �.�.
05.09.2022                                                        *
*/