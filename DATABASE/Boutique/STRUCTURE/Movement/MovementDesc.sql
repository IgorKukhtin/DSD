/*
  �������� 
    - ������� MovementDesc (������ �����������)
    - c�����
    - ��������
*/
 

-- Table: MovementDesc

-- DROP TABLE MovementDesc;

/*-------------------------------------------------------------------------------*/
CREATE TABLE MovementDesc
(
   Id                    SERIAL NOT NULL PRIMARY KEY, 
   Code                  TVarChar NOT NULL UNIQUE,
   ItemName              TVarChar
)
WITH (
  OIDS=FALSE
);
ALTER TABLE MovementDesc
  OWNER TO postgres;



/*-------------------------------------------------------------------------------*/

/*                                  �������                                      */




/*-------------------------------------------------------------------------------
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.   
 29.06.13             * SERIAL
*/
