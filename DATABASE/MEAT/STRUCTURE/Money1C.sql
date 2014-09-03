/*
  �������� 
    - ������� Money1C (������������� ������� �������)
    - ������
    - ��������
*/

-- Table: Movement

-- DROP TABLE Money1C;

/*-------------------------------------------------------------------------------*/
CREATE TABLE Money1C
(
  Id                     serial    NOT NULL PRIMARY KEY,
  UnitId                 Integer ,
  InvNumber              TVarChar ,
  OperDate               TDateTime ,
  ClientCode             Integer ,   
  ClientName             TVarChar ,   
  SummaIn                TFloat ,
  SummaOut               TFloat  
)
WITH (
  OIDS=FALSE
);

ALTER TABLE Money1C
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/



/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.   
*/
