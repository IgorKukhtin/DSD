/*
  �������� 
    - ������� HistoryCost_err - ��������� ����, ����� �������� ������
    - ������
    - ��������
*/


/*-------------------------------------------------------------------------------*/

CREATE TABLE HistoryCost_err(
   Id                    SERIAL NOT NULL PRIMARY KEY, 
   InsertDate            TDateTime NOT NULL,
   MovementId            Integer   NOT NULL
);

/*-------------------------------------------------------------------------------*/

/*                                  �������                                      */
CREATE INDEX idx_HistoryCost_err_InsertDate ON HistoryCost_err(InsertDate);
CREATE INDEX idx_HistoryCost_err_MovementId ON HistoryCost_err(MovementId);

/*-------------------------------------------------------------------------------*/


/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.   
 05.11.19             *
*/
