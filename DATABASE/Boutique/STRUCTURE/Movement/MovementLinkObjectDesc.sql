/*
  �������� 
    - ������� MovementLinkObjectDesc (������ ������ ����� �������� ����������� � �������� ��������)
    - ������
    - ��������
*/
-- Table: MovementLinkObjectDesc

-- DROP TABLE MovementLinkObjectDesc;

/*-------------------------------------------------------------------------------*/

CREATE TABLE MovementLinkObjectDesc
(
   Id                    SERIAL NOT NULL PRIMARY KEY, 
   Code                  TVarChar NOT NULL UNIQUE,
   ItemName              TVarChar
)
WITH (
  OIDS=FALSE
);
ALTER TABLE MovementLinkObjectDesc
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
