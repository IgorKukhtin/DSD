/*
  �������� 
    - ������� MovementLinkMovementDesc (������ ������ ����� �������� �����������)
    - ������
    - ��������
*/
-- Table: MovementLinkMovementDesc

-- DROP TABLE MovementLinkMovementDesc;

/*-------------------------------------------------------------------------------*/

CREATE TABLE MovementLinkMovementDesc
(
   Id                    SERIAL NOT NULL PRIMARY KEY, 
   Code                  TVarChar NOT NULL UNIQUE,
   ItemName              TVarChar
)
WITH (
  OIDS=FALSE
);
ALTER TABLE MovementLinkMovementDesc
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/

/*                                  �������                                      */



/*-------------------------------------------------------------------------------
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.   
 12.02.14                             * 
*/
