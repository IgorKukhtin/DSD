-- Function: gpInsertUpdate_Object_ModelService(Integer,Integer,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_ModelService(Integer,Integer,TVarChar,TVarChar,Integer,Integer,TVarChar);
--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_ModelService(Integer,Integer,TVarChar,TVarChar,Integer,Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_ModelService(Integer,Integer, Integer, TVarChar,TVarChar,Integer,Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ModelService(
 INOUT ioId                   Integer   ,    -- ���� ������� <������ ����������>
    IN inMaskId               Integer   ,    -- id ��� �����������      ���� ��������� �� ����� �������� ItemMaster � ItemChild
    IN inCode                 Integer   ,    -- ��� �������
    IN inName                 TVarChar  ,    -- �������� �������
    IN inComment              TVarChar  ,    -- ����������
    IN inUnitId               Integer   ,    -- �������������
    IN inModelServiceKindId   Integer   ,    -- ���� ������ ����������
    IN inisTrainee            Boolean   ,    -- �� �������� � ����� �����(��/��� - ������ ���� ��� �������)
    IN inSession              TVarChar       -- ������ ������������
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ModelService());
   vbUserId:= lpGetUserBySession (inSession);

   -- �������� ����
   IF NOT EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE Object_RoleAccessKey_View.UserId = vbUserId AND Object_RoleAccessKey_View.AccessKeyId = zc_Enum_Process_Update_Object_ModelService())
      AND vbUserId <> 5
   THEN
        RAISE EXCEPTION '������.%��� ���� �������������� = <%>.'
                      , CHR (13)
                      , (SELECT ObjectDesc.ItemName FROM ObjectDesc WHERE ObjectDesc.Id = zc_Object_ModelService())
                       ;
   END IF;

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_ModelService());

   -- �������� ���� ������������ ��� �������� <������������ >
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_ModelService(), inName);
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ModelService(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ModelService(), vbCode_calc, inName);

   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ModelService_Comment(), ioId, inComment);

   -- ��������� ����� � <��������������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ModelService_Unit(), ioId, inUnitId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ModelService_ModelServiceKind(), ioId, inModelServiceKindId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_ModelService_Trainee(), ioId, inisTrainee);

   IF COALESCE (inMaskId,0) <> 0
   THEN
        --ItemMaster
        PERFORM gpInsertUpdate_Object_ModelServiceItemMaster( ioId             := 0                      ::Integer   -- ���� ������� < ������� �������� ������ ����������>
                                                            , inMovementDescId := tmp.MovementDescId     ::TFloat    -- ��� ���������
                                                            , inRatio          := tmp.Ratio              ::TFloat    -- ����������� ��� ������ ������
                                                            , inComment        := tmp.Comment            ::TVarChar  -- ����������
                                                            , inModelServiceId := ioId                   ::Integer   -- ������ ����������
                                                            , inFromId         := tmp.FromId             ::Integer   -- �������������(�� ����)
                                                            , inToId           := tmp.ToId               ::Integer   -- �������������(����)
                                                            , inSelectKindId   := tmp.SelectKindId       ::Integer   -- ��� ������ ������
                                                            , inDocumentKindId := tmp.DocumentKindId     ::Integer   -- ��� ������ ������
                                                            , inSession        := inSession              ::TVarChar  -- ������ ������������
                                                            )
        FROM gpSelect_Object_ModelServiceItemMaster(FALSE, inSession) AS tmp
        WHERE tmp.ModelServiceId = inMaskId;
        --ItemChild
        PERFORM gpInsertUpdate_Object_ModelServiceItemChild( ioId             := 0                       ::Integer
                                                           , inComment        := tmp.Comment             ::TVarChar                            -- ����������
                                                           , inFromId         := tmp.FromId              ::Integer                             -- �����(�� ����)
                                                           , inToId           := tmp.ToId                ::Integer                             -- �����(����)
                                                           , inFromGoodsKindId:= tmp.FromGoodsKindId     ::Integer                             -- ��� ������(�� ����)
                                                           , inToGoodsKindId  := tmp.ToGoodsKindId       ::Integer                             -- ��� ������(����)
                                                           , inFromGoodsKindCompleteId  := tmp.FromGoodsKindCompleteId                         -- ��� ������(�� ����, ������� ���������)
                                                           , inToGoodsKindCompleteId    := tmp.ToGoodsKindCompleteId     ::Integer             -- ��� ������(����, ������� ���������)
                                                           , inModelServiceItemMasterId := tmp.ModelServiceItemMasterId  ::Integer             -- ������� �������
                                                           , inFromStorageLineId := tmp.FromStorageLineId                ::Integer             -- ����� ��-�� (�� ����)
                                                           , inToStorageLineId   := tmp.ToStorageLineId    ::Integer                           -- ����� ��-�� (����)
                                                           , inSession           := inSession              ::TVarChar  -- ������ ������������
                                                           )
        FROM
             (WITH
              -- ItemMaster ������ ��������
              tmpItemMaster AS (SELECT *
                                FROM gpSelect_Object_ModelServiceItemMaster(FALSE, inSession) AS tmp
                                WHERE tmp.ModelServiceId = ioId
                                )
            , tmpItemMasterMask AS (SELECT *
                                    FROM gpSelect_Object_ModelServiceItemMaster(FALSE, inSession) AS tmp
                                    WHERE tmp.ModelServiceId = inMaskId
                                    )
            --�� ����� ItemMaster ���� ������� �����, ��� ������ � ItemChild
            , tmpItemMasterUnion AS (SELECT tmpItemMaster.Id
                                          , tmpItemMasterMask.Id AS Id_mask
                                     FROM tmpItemMaster
                                          INNER JOIN tmpItemMasterMask ON COALESCE (tmpItemMasterMask.MovementDescId,0) = COALESCE (tmpItemMaster.MovementDescId,0)
                                                                      AND COALESCE (tmpItemMasterMask.Ratio,0) = COALESCE (tmpItemMaster.Ratio,0)
                                                                      AND COALESCE (tmpItemMasterMask.Comment,'') = COALESCE (tmpItemMaster.Comment,'')
                                                                      AND COALESCE (tmpItemMasterMask.FromId,0) = COALESCE (tmpItemMaster.FromId,0)
                                                                      AND COALESCE (tmpItemMasterMask.ToId,0) = COALESCE (tmpItemMaster.ToId,0)
                                                                      AND COALESCE (tmpItemMasterMask.SelectKindId,0) = COALESCE (tmpItemMaster.SelectKindId,0)
                                     )
            , tmpItemChildMask AS (SELECT * FROM gpSelect_Object_ModelServiceItemChild(FALSE,FALSE, inSession) AS tmp)

              SELECT tmpItemMasterUnion.Id AS ModelServiceItemMasterId
                   , tmpItemChildMask.Comment
                   , tmpItemChildMask.FromId
                   , tmpItemChildMask.ToId
                   , tmpItemChildMask.FromGoodsKindId
                   , tmpItemChildMask.ToGoodsKindId
                   , tmpItemChildMask.FromGoodsKindCompleteId
                   , tmpItemChildMask.ToGoodsKindCompleteId
                   , tmpItemChildMask.FromStorageLineId
                   , tmpItemChildMask.ToStorageLineId
              FROM tmpItemMasterUnion
                   INNER JOIN tmpItemChildMask ON tmpItemChildMask.ModelServiceItemMasterId = tmpItemMasterUnion.Id_mask
              ) AS tmp;

   END  IF;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.12.19         * inisTrainee
 19.10.13         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ModelService(0,0,'EREWG', 'ghygjf', 2,6,'2')
