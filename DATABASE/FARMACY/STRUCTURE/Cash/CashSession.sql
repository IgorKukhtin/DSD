/*
  �������� 
    - ������� CashSession (������ ��������� �����)
    - ������
    - ��������
*/


-- DROP TABLE CashSession;

/*-------------------------------------------------------------------------------*/
CREATE TABLE CashSession
(
  Id             TVarChar    NOT NULL PRIMARY KEY,
  LastConnect    TDateTime -- ���� ���������
);

ALTER TABLE CashSession
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/

/*
  �������� 
    - ������� CashSessionSnapShot (��������� �������� ��� � ��. ��� ������ ��������� �����)
    - ������
    - ��������
*/


-- DROP TABLE CashSessionSnapShot;

/*-------------------------------------------------------------------------------*/
CREATE TABLE CashSessionSnapShot
(
  CashSessionId   TVarChar    NOT NULL,
  ObjectId        INTEGER     NOT NULL, -- �����
  Price           TFloat      NOT NULL, -- ����
  Remains         TFloat      NOT NULL, -- �������
  MCSValue        TFloat      NULL,     -- ����������� �������� �������
  Reserved        TFloat      NULL,     -- � �������
  CONSTRAINT PK_CashSessionSnapShot PRIMARY KEY(CashSessionId,ObjectId)
);

ALTER TABLE CashSessionSnapShot
  OWNER TO postgres;

CREATE INDEX idx_CashSessionSnapShot ON CashSessionSnapShot(CashSessionId);
CREATE INDEX idx_CashSessionSnapShot_ObjectId ON CashSessionSnapShot(ObjectId);

-- CREATE INDEX idx_CashSessionSnapShot_ObjectId_CashSessionId ON CashSessionSnapShot(ObjectId, CashSessionId);
-- CREATE INDEX idx_CashSessionSnapShot_CashSessionId_ObjectId ON CashSessionSnapShot(CashSessionId, ObjectId);

/*-------------------------------------------------------------------------------*/



/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.   ��������� �.�.
10.09.2015                                           *
*/
