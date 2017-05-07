-- �������� - ������� Container + ������ + ��������

-------------------------------------------------------------------------------

CREATE TABLE Container(
   Id                    SERIAL   NOT NULL PRIMARY KEY, 
   DescId                Integer  NOT NULL, 
   ObjectId              Integer  NOT NULL, -- ����
   PartionId             Integer      NULL,
   Amount                TFloat   NOT NULL DEFAULT 0,
   ParentId              Integer      NULL,  
   KeyValue              TVarChar NOT NULL,
   WhereObjectId         Integer  NOT NULL,
   
   CONSTRAINT fk_Container_DescId    FOREIGN KEY (DescId)    REFERENCES ContainerDesc(Id),
   CONSTRAINT fk_Container_ObjectId  FOREIGN KEY (ObjectId)  REFERENCES Object(Id),
   CONSTRAINT fk_Container_PartionId FOREIGN KEY (PartionId) REFERENCES Object_PartionGoods(MovementItemId),
   CONSTRAINT fk_Container_ParentId  FOREIGN KEY (ParentId)  REFERENCES Container(Id)
);

-------------------------------------------------------------------------------

-- �������
CREATE INDEX idx_Container_KeyValue             ON Container (KeyValue);
CREATE INDEX idx_Container_WhereObjectId_Amount ON Container (whereobjectid, descid, amount, objectid);
CREATE INDEX idx_Container_ObjectId_DescId      ON Container (ObjectId, DescId);
CREATE INDEX idx_Container_PartionId            ON Container (PartionId);
CREATE INDEX idx_Container_DescId               ON Container (DescId);
CREATE INDEX idx_Container_ParentId             ON Container (ParentId); 

/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.   
19.09.02              * chage index
18.06.02                                         
11.07.02                                         
*/
