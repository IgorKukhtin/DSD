/*
  �������� 
    - ������� Movement (�����������)
    - ������
    - ��������
*/

-- Table: Movement

-- DROP TABLE Movement;

/*-------------------------------------------------------------------------------*/
CREATE TABLE Movement
(
  Id         serial    NOT NULL PRIMARY KEY,
  DescId     integer   NOT NULL,
  InvNumber  TVarChar          ,
  OperDate   TDateTime NOT NULL,
  StatusId   integer   NOT NULL,
  ParentId   Integer   ,
  CONSTRAINT fk_Movement_MovementDesc FOREIGN KEY (DescId)    REFERENCES MovementDesc (id),
  CONSTRAINT fk_Movement_StatusId FOREIGN KEY (StatusId)      REFERENCES Object (id),
  CONSTRAINT fk_Movement_ParentId FOREIGN KEY (ParentId)      REFERENCES Movement (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE Movement
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/

/*                                  �������                                      */


CREATE INDEX idx_Movement_OperDate_DescId ON Movement(OperDate, DescId);
CREATE INDEX idx_Movement_ParentId ON Movement(ParentId); 
CREATE INDEX idx_Movement_StatusId ON Movement(StatusId); -- ����������
CREATE INDEX idx_Movement_DescId_InvNumber ON Movement(DescId, zfConvert_StringToNumber(InvNumber));


/*-------------------------------------------------------------------------------*/


/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.   
*/
