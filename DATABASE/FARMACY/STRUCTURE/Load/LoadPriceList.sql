/*
  �������� 
    - ������� LoadPriceList (������������� ������� ��������)
    - ������
    - ��������
*/

-- Table: Movement

-- DROP TABLE LoadPriceList;

/*-------------------------------------------------------------------------------*/
CREATE TABLE LoadPriceList
(
  Id            serial    NOT NULL PRIMARY KEY,
  OperDate	TDateTime, -- ���� ���������
  JuridicalId	Integer , -- ����������� ����
  isAllGoodsConcat Boolean, -- ��� �� ������ ����� �����
  CONSTRAINT fk_LoadMovement_JuridicalId FOREIGN KEY (JuridicalId)    REFERENCES Object (id),
  CONSTRAINT fk_LoadMovement_NDSKindId   FOREIGN KEY (NDSKindId)      REFERENCES Object (id)
)
WITH (
  OIDS=FALSE
);

ALTER TABLE LoadPriceList
  OWNER TO postgres;
 
CREATE INDEX idx_LoadPriceList_JuridicalId ON LoadPriceList(JuridicalId); 
CREATE INDEX idx_LoadPriceList_NDSKindId   ON LoadPriceList(NDSKindId);


/*-------------------------------------------------------------------------------*/



/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.   
*/
