-- Function: gpInsertUpdate_Object_GoodsDivisionLock (Integer, TFloat, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsDivisionLock (Integer, Integer, Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsDivisionLock(
 INOUT ioId                       Integer   ,    -- ���� ������� < >
    IN inGoodsId                  Integer   ,    -- �����
    IN inUnitId                   Integer   ,    -- �������������
    IN inisLock                   Boolean   ,    -- ���������� ������� ������
    IN inSession                  TVarChar       -- ������ ������������
)
AS 
$BODY$
  DECLARE vbUserId       Integer;
  DECLARE vbisLock       Boolean;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;
    
    -- ���� ����� ������ ���� - ������� � ����� ����.-�����
    SELECT Object_GoodsDivisionLock.Id 
         , COALESCE(ObjectBoolean_GoodsDivisionLock_Lock.ValueData, False)  AS isLock
    INTO ioId
       , vbisLock
    FROM Object AS Object_GoodsDivisionLock
         INNER JOIN ObjectLink AS ObjectLink_GoodsDivisionLock_Goods
                               ON ObjectLink_GoodsDivisionLock_Goods.ObjectId = Object_GoodsDivisionLock.Id
                              AND ObjectLink_GoodsDivisionLock_Goods.DescId = zc_ObjectLink_GoodsDivisionLock_Goods()
                              AND ObjectLink_GoodsDivisionLock_Goods.ChildObjectId = inGoodsId
         INNER JOIN ObjectLink AS ObjectLink_GoodsDivisionLock_Unit
                               ON ObjectLink_GoodsDivisionLock_Unit.ObjectId = Object_GoodsDivisionLock.Id
                              AND ObjectLink_GoodsDivisionLock_Unit.DescId = zc_ObjectLink_GoodsDivisionLock_Unit()
                              AND ObjectLink_GoodsDivisionLock_Unit.ChildObjectId = inUnitId
         LEFT JOIN ObjectBoolean AS ObjectBoolean_GoodsDivisionLock_Lock
                                 ON ObjectBoolean_GoodsDivisionLock_Lock.ObjectId = Object_GoodsDivisionLock.Id
                                AND ObjectBoolean_GoodsDivisionLock_Lock.DescId = zc_ObjectBoolean_GoodsDivisionLock_Lock()
    WHERE Object_GoodsDivisionLock.DescId = zc_Object_GoodsDivisionLock();

    IF inisLock <> COALESCE (vbisLock, False)
    THEN

      -- ���������/�������� <������> �� ��
      ioId := lpInsertUpdate_Object (ioId, zc_Object_GoodsDivisionLock(), 0, '');

      -- ��������� ����� � <�����>
      PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsDivisionLock_Goods(), ioId, inGoodsId);

      -- ��������� ����� � <�������������>
      PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsDivisionLock_Unit(), ioId, inUnitId);

      -- ��������� �������� <���������� ������� ������>
      PERFORM lpInsertUpdate_objectBoolean(zc_ObjectBoolean_GoodsDivisionLock_Lock(), ioId, inisLock);

      -- ��������� ��������
      PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
          
    END  IF;
END;
$BODY$
LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 17.05.21                                                      *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_GoodsDivisionLock()