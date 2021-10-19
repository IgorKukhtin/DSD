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
  LastConnect    TDateTime, -- ���� ���������
  UserId         Integer,   -- ��������� 
  StartUpdate    TDateTime -- ���� ������ ����������
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
  CashSessionId       TVarChar    NOT NULL,
  ObjectId            INTEGER     NOT NULL, -- �����
  NDSKindId           Integer     NOT NULL, -- ���� ���
  DiscountExternalID  Integer     NOT NULL, -- ����� ��� ������� (���������� �����)
  PartionDateKindId   Integer     NOT NULL, -- ���� ����/�� ����
  DivisionPartiesID   Integer     NOT NULL, -- ���������� ������ � ����� ��� �������
  Price               TFloat      NOT NULL, -- ����
  Remains             TFloat      NOT NULL, -- �������
  MCSValue            TFloat      NULL,     -- ����������� �������� �������
  Reserved            TFloat      NULL,     -- � �������
  DeferredSend        TFloat      NULL,     -- � ���������� ������������
  DeferredTR          TFloat      NULL,     -- � ���������� ����������� ����������
  MinExpirationDate   TDateTime   NULL,     -- ���� ����. ���.
  MCSValueOld         TFloat      NULL,     -- ��� - �������� ������� �������� �� ��������� �������
  StartDateMCSAuto    TDateTime   NULL,     -- ���� ���. �������
  EndDateMCSAuto      TDateTime   NULL,     -- ���� �����. �������
  isMCSAuto           Boolean     NULL,     -- ����� - ��� �������� ��������� �� ������
  isMCSNotRecalcOld   Boolean     NULL,     -- ������������ ���� - �������� ������� �������� �� ��������� �������
  AccommodationId     Integer     NULL,     -- ���������� ������
  PartionDateDiscount TFloat      NULL,     -- ������ �� ���������� �����
  PriceWithVAT        TFloat      NULL,     -- ���� ��������� �������
  CONSTRAINT PK_CashSessionSnapShot PRIMARY KEY(CashSessionId,ObjectId,PartionDateKindId)
);

ALTER TABLE CashSessionSnapShot
  OWNER TO postgres;

CREATE INDEX idx_CashSessionSnapShot ON CashSessionSnapShot(CashSessionId);
CREATE INDEX idx_CashSessionSnapShot_ObjectId ON CashSessionSnapShot(ObjectId);

-- CREATE INDEX idx_CashSessionSnapShot_ObjectId_CashSessionId ON CashSessionSnapShot(ObjectId, CashSessionId);
-- CREATE INDEX idx_CashSessionSnapShot_CashSessionId_ObjectId ON CashSessionSnapShot(CashSessionId, ObjectId);
-- ALTER TABLE CashSessionSnapShot ADD DeferredTR          TFloat      NULL

/*-------------------------------------------------------------------------------*/



/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.   ��������� �.�.   ������� �.�.   ������ �.�.
14.08.2020                                                                         * DivisionPartiesID
19.06.2020                                                                         * DiscountExternalID
13.05.2019                                                                         * PartionDateKindId
22.08.2018                                                                         *
09.06.2017                                                           *
10.09.2015                                           *
*/
