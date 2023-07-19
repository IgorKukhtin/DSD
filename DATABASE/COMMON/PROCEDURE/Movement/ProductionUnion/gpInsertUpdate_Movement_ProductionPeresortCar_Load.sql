-- Function: gpInsertUpdate_Movement_ProductionPeresortCar_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProductionPeresortCar_Load(TDateTime, Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar,TVarChar
                                                                         , TFloat, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ProductionPeresortCar_Load(
    IN inOperDate            TDateTime, --
    IN inGoodsCode_child     Integer  , -- 
    IN inGoodsCode           Integer  , 
    IN inGoodsName           TVarChar , --  
    IN inInvNumber           TVarChar,
    IN inBodyTypeName        TVarChar,  --6
    IN inCarModelName        TVarChar,
    IN inCarTypeName         TVarChar,  --8
    IN inPassportNumber      TVarChar,
    IN inRelease             TFloat, --10
    IN inCarName             TVarChar,
    IN inEngineNum           TVarChar,  --12
    IN inVIN                 TVarChar,
    IN inUnitName            TVarChar,  --14
    IN inUnitName_Storage    TVarChar,
    IN inAreaUnitName        TVarChar,  --16
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
   DECLARE vbStorageId Integer;
   DECLARE vbUnitId_Storage Integer; 
   DECLARE vbUnitId Integer;
   DECLARE vbAreaUnitId Integer;
   DECLARE vbBodyTypeId Integer;
   DECLARE vbCarTypeId Integer;
   DECLARE vbCarId Integer;
   DECLARE vbCarModelId Integer;
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

    -- ����� Id �������. ������
    vbUnitId:= (SELECT Object.Id
                FROM Object
                WHERE TRIM (Object.ValueData) ILIKE TRIM (inUnitName)
                  AND Object.DescId IN (zc_Object_Unit())
                LIMIT 1 --
               );

    -- ������ �������
    IF COALESCE (vbUnitId, 0) = 0
    THEN
        vbUnitId:= (SELECT Object.Id
                    FROM Object
                    WHERE TRIM (zfCalc_Text_replace (Object.ValueData, CHR (39), '`')) ILIKE TRIM (inUnitName)
                      AND Object.DescId IN (zc_Object_Unit())
                    LIMIT 1 --
                   );
    END IF;
    -- ���� ��� ������ ��������, �� ������ ��������� �� ������ � �������� ���������� ��������
    IF COALESCE (vbUnitId, 0) = 0
    THEN
        RAISE EXCEPTION '������.�������� ������������� (������ ���) = <%> �� �������.%�������� �����������.', TRIM (inUnitName), CHR(13);
    END IF;


    -- ����� Id OC ������
    vbGoodsId_child:= (SELECT Object.Id
                       FROM Object
                       WHERE Object.objectCode = inGoodsCode_child
                         AND Object.DescId IN (zc_Object_Asset())  --zc_Object_Goods()
                       LIMIT 1 --
                      );
 
    -- ���� ������ OC ���, �� ������ ��������� �� ������ � �������� ���������� ��������
    IF COALESCE (vbGoodsId_child, 0) = 0
    THEN
        RAISE EXCEPTION '������. �� � ����� <%> �� ������� � �����������.%�������� �����������.', inGoodsCode_child, CHR(13);
    END IF;

    vbCarModelId:= (SELECT Object.Id
                   FROM Object
                   WHERE TRIM (Object.ValueData) ILIKE TRIM (inCarModelName)
                     AND Object.DescId IN (zc_Object_CarModel())
                   LIMIT 1 --
                  );
    -- ���� ���, �� �������
    IF COALESCE (vbCarModelId, 0) = 0
    THEN
        -- ������� <�������������>
       vbCarModelId := (SELECT tmp.ioId
                      FROM gpInsertUpdate_Object_CarModel (ioId      := 0    :: Integer
                                                        , inCode    := 0    :: Integer
                                                        , inName    := TRIM (inCarModelName) ::TVarChar  
                                                        , inSession := inSession            :: TVarChar
                                                         ) AS tmp);
    END IF;

    vbCarTypeId:= (SELECT Object.Id
                   FROM Object
                   WHERE TRIM (Object.ValueData) ILIKE TRIM (inCarTypeName)
                     AND Object.DescId IN (zc_Object_CarType())
                   LIMIT 1 --
                  );
    -- ���� ���, �� �������
    IF COALESCE (vbCarTypeId, 0) = 0
    THEN
        -- ������� <�������������>
       vbCarTypeId := (SELECT tmp.ioId
                      FROM gpInsertUpdate_Object_CarType (ioId      := 0    :: Integer
                                                        , inCode    := 0    :: Integer
                                                        , inName    := TRIM (inCarTypeName) ::TVarChar  
                                                        , inSession := inSession            :: TVarChar
                                                         ) AS tmp);
    END IF;
    
    vbBodyTypeId:= (SELECT Object.Id
                    FROM Object
                    WHERE TRIM (Object.ValueData) ILIKE TRIM (inBodyTypeName)
                      AND Object.DescId IN (zc_Object_BodyType())
                    LIMIT 1 --
                   );
    -- ���� ���, �� �������
    IF COALESCE (vbBodyTypeId, 0) = 0
    THEN
        -- ������� <�������������>
       vbBodyTypeId := (SELECT tmp.ioId
                        FROM gpInsertUpdate_Object_BodyType (ioId      := 0    :: Integer
                                                           , inCode    := 0    :: Integer
                                                           , inName    := TRIM (inBodyTypeName) ::TVarChar  
                                                           , inSession := inSession             :: TVarChar
                                                            ) AS tmp);
    END IF;

    
    --
    vbCarId:= (SELECT Object.Id
               FROM Object
               WHERE TRIM (Object.ValueData) ILIKE TRIM (inCarName)
                 AND Object.DescId IN (zc_Object_Car())
               LIMIT 1 --
              );
    -- ���� ���, �� ������
    IF COALESCE (vbCarId, 0) = 0
    THEN
        RAISE EXCEPTION '������. ���� % ��� �� <%> �� ������� � �����������.%�������� �����������.', TRIM (inCarName), TRIM (inGoodsName),  chr(13);
    END IF;
 
     -- ����� Id ������
    vbGoodsId:= (SELECT Object.Id
                 FROM Object
                 WHERE Object.ObjectCode = inGoodsCode
                   AND Object.DescId IN (zc_Object_Asset())
                 LIMIT 1 --
                );
    
    -- ���� ������ ������ ���, �� ������� ����� �� ����������� �����
    IF COALESCE (vbGoodsId, 0) = 0 
    THEN 
        vbGoodsId:= (SELECT Object.Id
                     FROM Object 
                         INNER JOIN ObjectString AS ObjectString_InvNumber
                                 ON ObjectString_InvNumber.ObjectId = Object.Id
                                AND ObjectString_InvNumber.DescId = zc_ObjectString_Asset_InvNumber()
                                AND TRIM (ObjectString_InvNumber.ValueData) = TRIM (inInvNumber)
                     WHERE Object.DescId IN (zc_Object_Asset())
                     LIMIT 1 --
                    );
    END IF;
 
    -- ���� ������ ������ ���, �� ������ ��������� �� ������ � �������� ���������� ��������
    IF COALESCE (vbGoodsId, 0) = 0
    THEN
        RAISE EXCEPTION '������. �� % � ����� <%>  ���.� <%> �� ������� � �����������.%�������� �����������.', TRIM (inGoodsName), inGoodsCode,inInvNumber,  chr(13);
    END IF;


    -- ��������� �� ������� �� �����
    PERFORM gpInsertUpdate_Object_Asset(ioId             := vbGoodsId                                       ::Integer       -- ���� ������� < �������� ��������>
                                      , inCode           := tmp.Code                                        ::Integer       -- ��� ������� 
                                      , inName           := tmp.Name                                        ::TVarChar      -- �������� ������� 
                                      , inRelease        := COALESCE (tmp.Release, ('01.01.'||inRelease) ::TDateTime )  ::TDateTime     -- ���� �������
                                      , inInvNumber      := COALESCE (tmp.InvNumber, inInvNumber)           ::TVarChar      -- ����������� �����
                                      , inFullName       := tmp.FullName                                    ::TVarChar      -- ������ �������� ��
                                      , inSerialNumber   := tmp.SerialNumber                                ::TVarChar      -- ��������� �����
                                      , inPassportNumber := COALESCE (tmp.PassportNumber, inPassportNumber) ::TVarChar      -- ����� ��������
                                      , inComment        := tmp.Comment                                     ::TVarChar      -- ����������
                                      , inAssetGroupId   := tmp.AssetGroupId                                ::Integer       -- ������ �� ������ �������� �������
                                      , inJuridicalId    := tmp.JuridicalId                                 ::Integer       -- ������ �� ����������� ����
                                      , inMakerId        := tmp.MakerId                                     ::Integer       -- ������ �� ������������� (��)
                                      , inCarId          := COALESCE (tmp.CarId, vbCarId)                   ::Integer       -- ������ �� ����
                                      , inAssetTypeId    := tmp.AssetTypeId                                 ::Integer       -- ��� ��
                                      , inPeriodUse      := tmp.PeriodUse                                   ::TFloat        -- ������ ������������
                                      , inProduction     := tmp.Production                                  ::TFloat        -- ������������������, ��
                                      , inKW             := tmp.Kw                                          ::TFloat        -- ������������ �������� KW 
                                      , inisDocGoods     := tmp.isDocGoods                                  ::Boolean       -- 
                                      , inSession        := inSession                                       ::TVarChar
                                      )
    FROM gpSelect_Object_Asset (inSession) AS tmp
    WHERE tmp.Id = vbGoodsId;  
    
    -- ��������� ���� ������� �� �����
    PERFORM gpInsertUpdate_Object_Car(ioId                     := vbCarId                                  ::Integer     -- ��                                                
                                    , incode                   := tmp.Code                                 ::Integer     -- ��� ����������                                    
                                    , inName                   := tmp.Name                                 ::TVarChar    -- ������������                                      
                                    , inRegistrationCertificate:= tmp.RegistrationCertificate              ::TVarChar    -- ����������                                        
                                    , inVIN                    := COALESCE (tmp.VIN, inVIN)                ::TVarChar    -- VIN ���                                           
                                    , inEngineNum              := COALESCE (tmp.EngineNum, inEngineNum)    ::TVarChar    -- ����� ���������                                   
                                    , inComment                := tmp.Comment                              ::TVarChar    -- ����������                                        
                                    , inCarModelId             := COALESCE (tmp.CarModelId, vbCarModelId)  ::Integer     -- ����� ����������                                  
                                    , inCarTypeId              := COALESCE (tmp.CarTypeId, vbCarTypeId)    ::Integer     -- ������ ����������                                 
                                    , inBodyTypeId             := COALESCE (tmp.BodyTypeId, vbBodyTypeId)  ::Integer     -- ��� ������                                        
                                    , inUnitId                 := COALESCE (tmp.UnitId, vbUnitId)          ::Integer     -- �������������                                     
                                    , inPersonalDriverId       := tmp.PersonalDriverId                     ::Integer     -- ��������� (��������)                              
                                    , inFuelMasterId           := tmp.FuelMasterId                         ::Integer     -- ��� ������� (��������)                            
                                    , inFuelChildId            := tmp.FuelChildId                          ::Integer     -- ��� ������� (��������������)                      
                                    , inJuridicalId            := tmp.JuridicalId                          ::Integer     -- ����������� ����(���������)                       
                                    --, inAssetId                := COALESCE (tmp.AssetId, vbGoodsId)        ::Integer     -- �������� ��������                               
                                    , inKoeffHoursWork         := tmp.KoeffHoursWork                       ::TFloat      -- �����. ��� ������ ������� ����� �� �������� ����� 
                                    , inPartnerMin             := tmp.PartnerMin                           ::TFloat      -- ���-�� ����� �� ��                                
                                    , inLength                 := tmp.Length                               ::TFloat      --                                                   
                                    , inWidth                  := tmp.Width                                ::TFloat      --                                                   
                                    , inHeight                 := tmp.Height                               ::TFloat      --                                                   
                                    , inWeight                 := tmp.Weight                               ::TFloat      --                                                   
                                    , inYear                   := COALESCE (tmp.Year, inRelease)           ::TFloat      --                                                   
                                    , inSession                := inSession                                ::TVarChar    -- ������������                                      
                                    )
    FROM gpSelect_Object_Car (FALSE, inSession) AS tmp
    WHERE tmp.Id = vbCarId; 

    
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
    vbStorageId := (SELECT Object_Storage.Id
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
    IF COALESCE (vbStorageId, 0) = 0
    THEN
       -- �������  <����� ��������>
       vbStorageId := (SELECT tmp.ioId
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
                                                , inStorageId              := vbStorageId     ::Integer   -- ����� ��������
                                                , inStorageId_child        := Null            ::Integer   -- ����� ��������
                                                , inPartNumber             := inSerialNumber  ::TVarChar  -- � �� ��� ��������
                                                , inPartNumber_child       := Null            ::TVarChar  -- � �� ��� �������� 
                                                , inModel                  := inCarModelName  ::TVarChar  -- Model
                                                , inModel_child            := Null            ::TVarChar  -- Model
                                                , inUserId                 := vbUserId
                                                 );

   
   
 if (vbUserId = 5 AND 1=0) OR vbUserId = 9457
 then
    RAISE EXCEPTION 'ok1 %   %    %    %  %',  lfGet_Object_ValueData (vbGoodsId_child), lfGet_Object_ValueData (vbGoodsId), vbStorageId, vbFromId,vbToId;
 end if;
                          

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.07.23         *
*/

-- ����
--