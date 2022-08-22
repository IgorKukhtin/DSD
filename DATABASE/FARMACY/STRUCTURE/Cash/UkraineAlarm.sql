/*
  �������� 
    - ������� UkraineAlarm (�������� �������)
    - ������
    - ��������
*/


-- DROP TABLE UkraineAlarm;

/*-------------------------------------------------------------------------------*/
CREATE TABLE UkraineAlarm
(
  Id             serial NOT NULL,
  regionId       Integer,    -- ������ 
  startDate      TDateTime,  -- ���� ������
  endDate        TDateTime,  -- ���� �����
  alertType      TVarChar,   -- ��� �������

  CONSTRAINT pk_UkraineAlarm PRIMARY KEY (Id)
);

ALTER TABLE UkraineAlarm
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/


/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.   ������� �.�.   ������ �.�.
22.08.2022                                                        *
*/
