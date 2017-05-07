-- �������� - ������� Object + ������ + ��������

-------------------------------------------------------------------------------

CREATE TABLE Object(
   Id                    SERIAL   NOT NULL PRIMARY KEY, 
   DescId                Integer  NOT NULL,
   ObjectCode            Integer  NOT NULL,
   ValueData             TVarChar NOT NULL,
   AccessKeyId           Integer      NULL,
   IsErased              Boolean  NOT NULL DEFAULT FALSE,

   CONSTRAINT fk_Object_DescId FOREIGN KEY (DescId) REFERENCES ObjectDesc(Id)
);

-------------------------------------------------------------------------------

-- �������
CREATE INDEX idx_Object_DescId            ON Object (DescId);
CREATE INDEX idx_Object_DescId_ValueData  ON Object (DescId, ValueData);
CREATE INDEX idx_Object_DescId_ObjectCode ON Object (DescId, ObjectCode);

-- !!! CLUSTER !!!
CLUSTER Object_pkey ON Object; 

/*-------------------------------------------------------------------------------*/
/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.   
 30.10.13             * NOT NULL: ObjectCode, ValueData
 27.06.13             *
*/




