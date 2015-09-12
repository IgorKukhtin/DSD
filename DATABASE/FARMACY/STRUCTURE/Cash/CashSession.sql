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

/*-------------------------------------------------------------------------------*/



/*
 ����������:
 ������� ����������:
 ����         �����
 ----------------
                 ���������� �.�.   ������ �.�.   ��������� �.�.
10.09.2015                                           *
*/
