-- Function: gpInsertUpdate_Movement_ProductionPeresortAsset_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProductionPeresortAsset_Load(TDateTime, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar,TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ProductionPeresortAsset_Load(
    IN inOperDate            TDateTime, --
    IN inGoodsCode_child     Integer  , -- 
    IN inGoodsCode           Integer  , 
    IN inGoodsName           TVarChar , --  
    IN inInvNumber           TVarChar,
    IN inSerialNumber        TVarChar,
    IN inModel               TVarChar,
    IN inUnitName            TVarChar,
    IN inUnitName_Storage    TVarChar,
    IN inAreaUnitName        TVarChar,
    IN inRoom                TVarChar,
    IN inBranchName          TVarChar,
    IN inFromName            TVarChar,
    IN inToName              TVarChar , -- 
    IN inSession             TVarChar   -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbMovementItemId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbGoodsId_child Integer;
   DECLARE vbFromId Integer;
   DECLARE vbToId Integer;
   DECLARE vbStoregeId Integer;
   DECLARE vbUnitId_Storage Integer;
   DECLARE vbAreaUnitId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProductionUnion());

    IF TRIM (inFromName) = ''
       AND TRIM (inToName) = ''
       AND TRIM (inGoodsName) = ''
    THEN
        RETURN;
    END IF;


    -- ����� Id �� ����
    vbFromId:= (SELECT Object.Id
                  FROM Object
                  WHERE TRIM (Object.ValueData) ILIKE TRIM (inFromName)
                    AND Object.DescId IN (zc_Object_Unit(), zc_Object_Member() )
                  LIMIT 1 --
                 );
    -- ������ �������
    IF COALESCE (vbFromId, 0) = 0
    THEN
        vbFromId:= (SELECT Object.Id
                      FROM Object
                      WHERE TRIM (zfCalc_Text_replace (Object.ValueData, CHR (39), '`')) ILIKE TRIM (inFromName)
                        AND Object.DescId IN (zc_Object_Unit(), zc_Object_Member() )
                      LIMIT 1 --
                     );
    END IF;

    -- ���� ��� ������ ��������, �� ������ ��������� �� ������ � �������� ���������� ��������
    IF COALESCE (vbFromId, 0) = 0
    THEN
        RAISE EXCEPTION '������.�������� �� ���� = <%> �� �������.%�������� �����������.', TRIM (inFromName), CHR(13);
    END IF;


    -- ����� Id ����
    vbToId:= (SELECT Object.Id
                  FROM Object
                  WHERE TRIM (Object.ValueData) ILIKE TRIM (inToName)
                    AND Object.DescId IN (zc_Object_Unit(), zc_Object_Member() )
                  LIMIT 1 --
                 );

    -- ������ �������
    IF COALESCE (vbToId, 0) = 0
    THEN
        vbToId:= (SELECT Object.Id
                      FROM Object
                      WHERE TRIM (zfCalc_Text_replace (Object.ValueData, CHR (39), '`')) ILIKE TRIM (inToName)
                        AND Object.DescId IN (zc_Object_Unit(), zc_Object_Member() )
                      LIMIT 1 --
                     );
    END IF;
    -- ���� ��� ������ ��������, �� ������ ��������� �� ������ � �������� ���������� ��������
    IF COALESCE (vbToId, 0) = 0
    THEN
        RAISE EXCEPTION '������.�������� ���� = <%> �� �������.%�������� �����������.', TRIM (inToName), CHR(13);
    END IF;

    -- ����� Id OC ������
    vbGoodsId_child:= (SELECT Object.Id
                       FROM Object
                       WHERE Object.objectCode = inGoodsCode_child
                         AND Object.DescId = zc_Object_Goods()
                       LIMIT 1 --
                      );
 
    -- ���� ������ OC ���, �� ������ ��������� �� ������ � �������� ���������� ��������
    IF COALESCE (vbGoodsId_child, 0) = 0
    THEN
        RAISE EXCEPTION '������. �� � ����� <%> �� ������� � �����������.%�������� �����������.', inGoodsCode_child, CHR(13);
    END IF;
 
     -- ����� Id ������
    vbGoodsId:= (SELECT Object.Id
                 FROM Object
                 WHERE Object.ObjectCode = inGoodsCode
                   AND Object.DescId = zc_Object_Goods()
                 LIMIT 1 --
                );
 
    -- ���� ������ ������ ���, �� ������ ��������� �� ������ � �������� ���������� ��������
    IF COALESCE (vbGoodsId, 0) = 0
    THEN
        RAISE EXCEPTION '������. �� % � ����� <%> �� ������� � �����������.%�������� �����������.', TRIM (inGoodsName), inGoodsCode, chr(13);
    END IF;

    -- ����� �� ������������� (����� ��������)
    vbUnitId_Storage := (SELECT Object.Id
                           FROM Object
                           WHERE TRIM (Object.ValueData) ILIKE TRIM (inUnitName_Storage)
                             AND Object.DescId = zc_Object_Unit()
                           LIMIT 1 --
                          );
     -- ���� ��� ������ ��������, �� ������ ��������� �� ������ � �������� ���������� ��������
    IF COALESCE (vbUnitId_Storage, 0) = 0
    THEN
        RAISE EXCEPTION '������.�� ������� ����� �������� = <%> ��� <%> <%>.%�������� �����������.', TRIM (inUnitName_Storage), inInvNumber, inGoodsName, chr(13);
    END IF;

    -- ����� <������� (����� ��������)>, ���� ��� ������ �������
    vbAreaUnitId := (SELECT Object.Id
                     FROM Object
                     WHERE TRIM (Object.ValueData) ILIKE TRIM (inAreaUnitName)
                       AND Object.DescId = zc_Object_AreaUnit()
                     LIMIT 1 --
                    );
    -- ���� ��� ������
    IF COALESCE (vbAreaUnitId, 0) = 0
    THEN
       -- ������� <������� (����� ��������)>
       vbAreaUnitId := (SELECT tmp.ioId
                        FROM gpInsertUpdate_Object_AreaUnit (ioId      := 0    :: Integer
                                                           , inCode    := 0    :: Integer
                                                           , inName    := TRIM (inAreaUnitName) ::TVarChar
                                                           , inSession := inSession             :: TVarChar
                                                            ) AS tmp);
    END IF;

    -- ����� <����� ��������>
    vbStoregeId := (SELECT Object_Storage.Id
                    FROM Object AS Object_Storage
                        INNER JOIN ObjectString AS ObjectString_Storage_Room
                                                ON ObjectString_Storage_Room.ObjectId  = Object_Storage.Id 
                                               AND ObjectString_Storage_Room.DescId    = zc_ObjectString_Storage_Room()
                                               AND ObjectString_Storage_Room.ValueData = inRoom
                        INNER JOIN ObjectLink AS ObjectLink_Storage_Unit
                                              ON ObjectLink_Storage_Unit.ObjectId = Object_Storage.Id 
                                             AND ObjectLink_Storage_Unit.DescId = zc_ObjectLink_Storage_Unit()
                                             AND ObjectLink_Storage_Unit.ChildObjectId = vbUnitId_Storage
                        INNER JOIN ObjectLink AS ObjectLink_Storage_AreaUnit
                                              ON ObjectLink_Storage_AreaUnit.ObjectId = Object_Storage.Id 
                                             AND ObjectLink_Storage_AreaUnit.DescId = zc_ObjectLink_Storage_AreaUnit()
                                             AND ObjectLink_Storage_AreaUnit.ChildObjectId = vbAreaUnitId
                    WHERE Object_Storage.DescId = zc_Object_Storage() 
                   );
    
    -- ���� ��� ������
    IF COALESCE (vbStoregeId, 0) = 0
    THEN
       -- �������  <����� ��������>
       vbStoregeId := (SELECT tmp.ioId
                       FROM gpInsertUpdate_Object_Storage (ioId      := 0    :: Integer
                                                         , inCode    := 0    :: Integer
                                                         , inName    := (TRIM (inUnitName_Storage)||' '||TRIM (inAreaUnitName)||' '||TRIM (inRoom)) ::TVarChar
                                                         , inComment := Null ::TVarChar
                                                         , inAddress := Null ::TVarChar
                                                         , inUnitId  := vbUnitId_Storage   ::Integer
                                                         , inAreaUnitName:= inAreaUnitName ::TVarChar
                                                         , inRoom    := inRoom             ::TVarChar
                                                         , inSession := inSession          ::TVarChar
                                                          ) AS tmp);
    END IF;


    -- ����� �������� zc_Movement_Production �� ���� � �� ���� / ����.
    SELECT Movement.Id INTO vbMovementId
    FROM Movement
         INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.ObjectId   = vbFromId
                                      AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
         INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.ObjectId   = vbToId
                                      AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
         INNER JOIN MovementBoolean AS MovementBoolean_Peresort
                                    ON MovementBoolean_Peresort.MovementId = Movement.Id
                                   AND MovementBoolean_Peresort.DescId = zc_MovementBoolean_Peresort()
                                   AND MovementBoolean_Peresort.ValueData = TRUE
    WHERE Movement.OperDate = inOperDate
      AND Movement.DescId = zc_Movement_ProductionUnion()
      AND Movement.StatusId = zc_Enum_Status_UnComplete();

    --
    IF COALESCE (vbMovementId, 0) = 0 THEN
       -- ���� ������ ��������� ��� - ������� ���
       vbMovementId := lpInsertUpdate_Movement_ProductionUnion (ioId             := 0
                                                              , inInvNumber      := NEXTVAL ('Movement_ProductionUnion_seq') :: TVarChar
                                                              , inOperDate       := inOperDate
                                                              , inFromId         := vbFromId
                                                              , inToId           := vbToId
                                                              , inDocumentKindId := 0          --inDocumentKindId
                                                              , inIsPeresort     := TRUE
                                                              , inUserId         := vbUserId
                                                              );
    END IF;


    -- ������� �����  ������ ��� ��� vbGoodsId � ������� � ������, � � ������� inPartionGoods
    SELECT MovementItem.Id INTO vbMovementItemId
    FROM MovementItem   
         JOIN MovementItem AS MovementItemChild ON MovementItemChild.MovementId = vbMovementId
                          AND MovementItemChild.ParentId   = MovementItem.Id
                          AND MovementItemChild.DescId     = zc_MI_Child()
                          AND MovementItemChild.isErased   = FALSE
                          AND MovementItemChild.ObjectId   = vbGoodsId_child

         LEFT JOIN MovementItemString AS MIString_PartionGoods
                                      ON MIString_PartionGoods.MovementItemId = MovementItem.Id
                                     AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()

    WHERE MovementItem.MovementId = vbMovementId
      AND MovementItem.DescId = zc_MI_Master()
      AND MovementItem.isErased = FALSE
      AND MovementItem.ObjectId = vbGoodsId
      AND COALESCE (MIString_PartionGoods.ValueData, '') = COALESCE (inInvNumber, '')
     ;
    
    PERFORM lpInsertUpdate_MI_ProductionPeresort (ioId                     := COALESCE (vbMovementItemId,0)
                                                , inMovementId             := vbMovementId
                                                , inGoodsId                := vbGoodsId
                                                , inGoodsId_child          := vbGoodsId_child
                                                , inGoodsKindId            := Null ::Integer
                                                , inGoodsKindId_Complete   := Null ::Integer
                                                , inGoodsKindId_child      := Null ::Integer
                                                , inGoodsKindId_Complete_child:= Null ::Integer
                                                , inAmount                 := 1
                                                , inAmount_child           := 1
                                                , inPartionGoods           := inInvNumber ::TVarChar
                                                , inPartionGoods_child     := Null ::TVarChar
                                                , inPartionGoodsDate       := Null ::TDateTime
                                                , inPartionGoodsDate_child := Null ::TDateTime
                                                , inStorageId              := vbStoregeId     ::Integer   -- ����� ��������
                                                , inStorageId_child        := Null            ::Integer   -- ����� ��������
                                                , inPartNumber             := inSerialNumber  ::TVarChar  -- � �� ��� ��������
                                                , inPartNumber_child       := Null            ::TVarChar  -- � �� ��� �������� 
                                                , inModel                  := inModel         ::TVarChar  -- Model
                                                , inModel_child            := Null            ::TVarChar  -- Model
                                                , inUserId                 := vbUserId
                                                 );

   
   
 if vbUserId = 5 AND 1=0
 then
    RAISE EXCEPTION 'ok1 %   %    %    %  %',  lfGet_Object_ValueData (vbGoodsId_child), lfGet_Object_ValueData (vbGoodsId), vbStoregeId, vbFromId,vbToId;
 end if;
                          

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.05.23         *
*/

-- ����
--