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
    IN inSession             TVarChar   -- сессия пользователя
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
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProductionUnion());

    IF TRIM (inFromName) = ''
       AND TRIM (inToName) = ''
       AND TRIM (inGoodsName) = ''
    THEN
        RETURN;
    END IF;


    -- Найти Id от кого
    vbFromId:= (SELECT Object.Id
                  FROM Object
                  WHERE TRIM (Object.ValueData) ILIKE TRIM (inFromName)
                    AND Object.DescId IN (zc_Object_Unit(), zc_Object_Member() )
                  LIMIT 1 --
                 );
    -- вторая попытка
    IF COALESCE (vbFromId, 0) = 0
    THEN
        vbFromId:= (SELECT Object.Id
                      FROM Object
                      WHERE TRIM (zfCalc_Text_replace (Object.ValueData, CHR (39), '`')) ILIKE TRIM (inFromName)
                        AND Object.DescId IN (zc_Object_Unit(), zc_Object_Member() )
                      LIMIT 1 --
                     );
    END IF;

    -- Если нет такого элемента, то выдать сообщение об ошибке и прервать выполнение загрузки
    IF COALESCE (vbFromId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Значение От кого = <%> не найдено.%Загрузка остановлена.', TRIM (inFromName), CHR(13);
    END IF;


    -- Найти Id кому
    vbToId:= (SELECT Object.Id
                  FROM Object
                  WHERE TRIM (Object.ValueData) ILIKE TRIM (inToName)
                    AND Object.DescId IN (zc_Object_Unit(), zc_Object_Member() )
                  LIMIT 1 --
                 );

    -- вторая попытка
    IF COALESCE (vbToId, 0) = 0
    THEN
        vbToId:= (SELECT Object.Id
                      FROM Object
                      WHERE TRIM (zfCalc_Text_replace (Object.ValueData, CHR (39), '`')) ILIKE TRIM (inToName)
                        AND Object.DescId IN (zc_Object_Unit(), zc_Object_Member() )
                      LIMIT 1 --
                     );
    END IF;
    -- Если нет такого элемента, то выдать сообщение об ошибке и прервать выполнение загрузки
    IF COALESCE (vbToId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Значение Кому = <%> не найдено.%Загрузка остановлена.', TRIM (inToName), CHR(13);
    END IF;

    -- Найти Id Подразд. партия
    vbUnitId:= (SELECT Object.Id
                FROM Object
                WHERE TRIM (Object.ValueData) ILIKE TRIM (inUnitName)
                  AND Object.DescId IN (zc_Object_Unit())
                LIMIT 1 --
               );

    -- вторая попытка
    IF COALESCE (vbUnitId, 0) = 0
    THEN
        vbUnitId:= (SELECT Object.Id
                    FROM Object
                    WHERE TRIM (zfCalc_Text_replace (Object.ValueData, CHR (39), '`')) ILIKE TRIM (inUnitName)
                      AND Object.DescId IN (zc_Object_Unit())
                    LIMIT 1 --
                   );
    END IF;
    -- Если нет такого элемента, то выдать сообщение об ошибке и прервать выполнение загрузки
    IF COALESCE (vbUnitId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Значение Подразделение (партия ТМЦ) = <%> не найдено.%Загрузка остановлена.', TRIM (inUnitName), CHR(13);
    END IF;


    -- Найти Id OC расход
    vbGoodsId_child:= (SELECT Object.Id
                       FROM Object
                       WHERE Object.objectCode = inGoodsCode_child
                         AND Object.DescId IN (zc_Object_Asset())  --zc_Object_Goods()
                       LIMIT 1 --
                      );
 
    -- Если такого OC нет, то выдать сообщение об ошибке и прервать выполнение загрузки
    IF COALESCE (vbGoodsId_child, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка. ОС с кодом <%> не найдено в справочнике.%Загрузка остановлена.', inGoodsCode_child, CHR(13);
    END IF;

    vbCarModelId:= (SELECT Object.Id
                   FROM Object
                   WHERE TRIM (Object.ValueData) ILIKE TRIM (inCarModelName)
                     AND Object.DescId IN (zc_Object_CarModel())
                   LIMIT 1 --
                  );
    -- Если нет, то создаем
    IF COALESCE (vbCarModelId, 0) = 0
    THEN
        -- создаем <Производителя>
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
    -- Если нет, то создаем
    IF COALESCE (vbCarTypeId, 0) = 0
    THEN
        -- создаем <Производителя>
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
    -- Если нет, то создаем
    IF COALESCE (vbBodyTypeId, 0) = 0
    THEN
        -- создаем <Производителя>
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
    -- Если нет, то ошибка
    IF COALESCE (vbCarId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка. Авто % для ОС <%> не найдено в справочнике.%Загрузка остановлена.', TRIM (inCarName), TRIM (inGoodsName),  chr(13);
    END IF;
 
     -- Найти Id товара
    vbGoodsId:= (SELECT Object.Id
                 FROM Object
                 WHERE Object.ObjectCode = inGoodsCode
                   AND Object.DescId IN (zc_Object_Asset())
                 LIMIT 1 --
                );
    
    -- Если такого товара нет, то пробуем найти по Инвентарный номер
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
 
    -- Если такого товара нет, то выдать сообщение об ошибке и прервать выполнение загрузки
    IF COALESCE (vbGoodsId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка. ОС % с кодом <%>  инв.№ <%> не найдено в справочнике.%Загрузка остановлена.', TRIM (inGoodsName), inGoodsCode,inInvNumber,  chr(13);
    END IF;


    -- обновляем ОС данными из файла
    PERFORM gpInsertUpdate_Object_Asset(ioId             := vbGoodsId                                       ::Integer       -- ключ объекта < Основные средства>
                                      , inCode           := tmp.Code                                        ::Integer       -- Код объекта 
                                      , inName           := tmp.Name                                        ::TVarChar      -- Название объекта 
                                      , inRelease        := COALESCE (tmp.Release, ('01.01.'||inRelease) ::TDateTime )  ::TDateTime     -- Дата выпуска
                                      , inInvNumber      := COALESCE (tmp.InvNumber, inInvNumber)           ::TVarChar      -- Инвентарный номер
                                      , inFullName       := tmp.FullName                                    ::TVarChar      -- Полное название ОС
                                      , inSerialNumber   := tmp.SerialNumber                                ::TVarChar      -- Заводской номер
                                      , inPassportNumber := COALESCE (tmp.PassportNumber, inPassportNumber) ::TVarChar      -- Номер паспорта
                                      , inComment        := tmp.Comment                                     ::TVarChar      -- Примечание
                                      , inAssetGroupId   := tmp.AssetGroupId                                ::Integer       -- ссылка на группу основных средств
                                      , inJuridicalId    := tmp.JuridicalId                                 ::Integer       -- ссылка на Юридические лица
                                      , inMakerId        := tmp.MakerId                                     ::Integer       -- ссылка на Производитель (ОС)
                                      , inCarId          := COALESCE (tmp.CarId, vbCarId)                   ::Integer       -- ссылка на авто
                                      , inAssetTypeId    := tmp.AssetTypeId                                 ::Integer       -- Тип ОС
                                      , inPeriodUse      := tmp.PeriodUse                                   ::TFloat        -- период эксплуатации
                                      , inProduction     := tmp.Production                                  ::TFloat        -- Производительность, кг
                                      , inKW             := tmp.Kw                                          ::TFloat        -- Потребляемая Мощность KW 
                                      , inisDocGoods     := tmp.isDocGoods                                  ::Boolean       -- 
                                      , inSession        := inSession                                       ::TVarChar
                                      )
    FROM gpSelect_Object_Asset (inSession) AS tmp
    WHERE tmp.Id = vbGoodsId;  
    
    -- обновляем Авто данными из файла
    PERFORM gpInsertUpdate_Object_Car(ioId                     := vbCarId                                  ::Integer     -- ид                                                
                                    , incode                   := tmp.Code                                 ::Integer     -- код автомобиля                                    
                                    , inName                   := tmp.Name                                 ::TVarChar    -- наименование                                      
                                    , inRegistrationCertificate:= tmp.RegistrationCertificate              ::TVarChar    -- Техпаспорт                                        
                                    , inVIN                    := COALESCE (tmp.VIN, inVIN)                ::TVarChar    -- VIN код                                           
                                    , inEngineNum              := COALESCE (tmp.EngineNum, inEngineNum)    ::TVarChar    -- Номер двигателя                                   
                                    , inComment                := tmp.Comment                              ::TVarChar    -- Примечание                                        
                                    , inCarModelId             := COALESCE (tmp.CarModelId, vbCarModelId)  ::Integer     -- Марка автомобиля                                  
                                    , inCarTypeId              := COALESCE (tmp.CarTypeId, vbCarTypeId)    ::Integer     -- Модель автомобиля                                 
                                    , inBodyTypeId             := COALESCE (tmp.BodyTypeId, vbBodyTypeId)  ::Integer     -- Тип кузова                                        
                                    , inUnitId                 := COALESCE (tmp.UnitId, vbUnitId)          ::Integer     -- Подразделение                                     
                                    , inPersonalDriverId       := tmp.PersonalDriverId                     ::Integer     -- Сотрудник (водитель)                              
                                    , inFuelMasterId           := tmp.FuelMasterId                         ::Integer     -- Вид топлива (основной)                            
                                    , inFuelChildId            := tmp.FuelChildId                          ::Integer     -- Вид топлива (дополнительный)                      
                                    , inJuridicalId            := tmp.JuridicalId                          ::Integer     -- Юридическое лицо(стороннее)                       
                                    --, inAssetId                := COALESCE (tmp.AssetId, vbGoodsId)        ::Integer     -- Основные средства                               
                                    , inKoeffHoursWork         := tmp.KoeffHoursWork                       ::TFloat      -- коэфф. для модели Рабочее время из путевого листа 
                                    , inPartnerMin             := tmp.PartnerMin                           ::TFloat      -- Кол-во минут на ТТ                                
                                    , inLength                 := tmp.Length                               ::TFloat      --                                                   
                                    , inWidth                  := tmp.Width                                ::TFloat      --                                                   
                                    , inHeight                 := tmp.Height                               ::TFloat      --                                                   
                                    , inWeight                 := tmp.Weight                               ::TFloat      --                                                   
                                    , inYear                   := COALESCE (tmp.Year, inRelease)           ::TFloat      --                                                   
                                    , inSession                := inSession                                ::TVarChar    -- Пользователь                                      
                                    )
    FROM gpSelect_Object_Car (FALSE, inSession) AS tmp
    WHERE tmp.Id = vbCarId; 

    
    -- Найди Ид Подразделения (Место хранение)
    vbUnitId_Storage := (SELECT Object.Id
                           FROM Object
                           WHERE TRIM (Object.ValueData) ILIKE TRIM (inUnitName_Storage)
                             AND Object.DescId = zc_Object_Unit()
                           LIMIT 1 --
                          );
     -- Если нет такого элемента, то выдать сообщение об ошибке и прервать выполнение загрузки
    IF COALESCE (vbUnitId_Storage, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Не найдено место хранения = <%> для <%> <%>.%Загрузка остановлена.', TRIM (inUnitName_Storage), inInvNumber, inGoodsName, chr(13);
    END IF;

    -- Поиск <Участок (Место хранения)>, если нет такого создаем
    vbAreaUnitId := (SELECT Object.Id
                     FROM Object
                     WHERE TRIM (Object.ValueData) ILIKE TRIM (inAreaUnitName)
                       AND Object.DescId = zc_Object_AreaUnit()
                     LIMIT 1 --
                    );
    -- Если нет такого
    IF COALESCE (vbAreaUnitId, 0) = 0
    THEN
       -- создаем <Участок (Место хранения)>
       vbAreaUnitId := (SELECT tmp.ioId
                        FROM gpInsertUpdate_Object_AreaUnit (ioId      := 0    :: Integer
                                                           , inCode    := 0    :: Integer
                                                           , inName    := TRIM (inAreaUnitName) ::TVarChar
                                                           , inSession := inSession             :: TVarChar
                                                            ) AS tmp);
    END IF;

    -- Поиск <Место хранения>
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
    
    -- Если нет такого
    IF COALESCE (vbStorageId, 0) = 0
    THEN
       -- создаем  <Место хранения>
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


    -- Поиск документ zc_Movement_Production по дате и от кого / кому.
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
       -- Если такого документа нет - создать его
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


    -- пробуем Найти  строку док для vbGoodsId в мастере и чайлде, и с партией inPartionGoods
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
                                                , inStorageId              := vbStorageId     ::Integer   -- Место хранения
                                                , inStorageId_child        := Null            ::Integer   -- Место хранения
                                                , inPartNumber             := inSerialNumber  ::TVarChar  -- № по тех паспорту
                                                , inPartNumber_child       := Null            ::TVarChar  -- № по тех паспорту 
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
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.07.23         *
*/

-- тест
--