 -- Function: gpInsertUpdate_Object_Unit_CFO_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit_CFO_Load (Integer, TVarChar, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Unit_CFO_Load(
    IN inUnitCode      Integer   , -- ��� ������� <�����>
    IN inUnitName      TVarChar    , -- 
    IN inCFOName  TVarChar    , -- 
    IN inSession        TVarChar    -- ������ ������������
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbCFOId Integer;
   
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);


     -- !!!������ �������������  - ����������!!!
     IF COALESCE (inUnitName, '') = '' THEN
        RETURN; -- !!!�����!!!
     END IF;

     -- !!!������ ��� - ����������!!!
     IF COALESCE (TRIM (inCFOName), '') = '' THEN
        RETURN; -- !!!�����!!!
     END IF;

     -- !!!����� �� ������!!!
     vbUnitId:= (SELECT Object_Unit.Id
                 FROM Object AS Object_Unit
                 WHERE UPPER (TRIM (Object_Unit.ValueData)) = UPPER (TRIM (inUnitName))
                   AND Object_Unit.DescId     = zc_Object_Unit()
                );
     -- ��������
     IF COALESCE (vbUnitId, 0) = 0 THEN
        RETURN;
        RAISE EXCEPTION '������.�� ������� ������������� <%> .', inUnitName;
     END IF;

     --������� ����� ���
     vbCFOId := ( SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_CFO() AND UPPER (TRIM (Object.ValueData)) = UPPER (TRIM (inCFOName)) );

     /*IF COALESCE (vbCFOId,0) = 0
     THEN
         RAISE EXCEPTION '������.������ ���������� <%> �� �������', inCFOName;
     END IF;
      */
     --�������
     IF COALESCE (vbCFOId,0) = 0
     THEN
         --�������
         vbCFOId := (SELECT tmp.ioId
                           FROM gpInsertUpdate_Object_CFO (ioId       := 0         :: Integer
                                                         , inCode     := 0         :: Integer
                                                         , inName     := TRIM (inCFOName) :: TVarChar
                                                         , inMemberId := Null      ::Integer
                                                         , inComment  := Null      ::TVarChar
                                                         , inSession  := inSession :: TVarChar
                                                          ) AS tmp);
     END IF;
     
     
     PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Unit_CFO(), vbUnitId, vbCFOId);
    
     RAISE EXCEPTION '����. ��. <%> / <%>', vbUnitId, vbCFOId;
  
     IF vbUserId = 9457 OR vbUserId = 5
     THEN
           RAISE EXCEPTION '����. ��. <%> / <%>', vbUnitId, vbCFOId; 
     END IF;   

     -- ��������� ��������
     PERFORM lpInsert_ObjectProtocol (vbUnitId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.10.25         *
*/

-- ����
--
