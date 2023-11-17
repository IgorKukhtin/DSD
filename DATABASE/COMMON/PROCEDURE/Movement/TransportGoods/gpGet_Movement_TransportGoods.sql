-- Function: gpGet_Movement_TransportGoods()

DROP FUNCTION IF EXISTS gpGet_Movement_TransportGoods (Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_TransportGoods(
    IN inMovementId       Integer  , -- ключ Документа
    IN inMovementId_Sale  Integer  , -- ключ Документа продажа или возврат 
    IN inOperDate         TDateTime , --
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, IdBarCode TVarChar
             , InvNumber TVarChar, OperDate TDateTime
             , InvNumberMark TVarChar
             , MovementId_Sale Integer, InvNumber_Sale TVarChar, OperDate_Sale TDateTime
             , RouteId Integer, RouteName TVarChar
             , CarId Integer, CarName TVarChar, CarModelId Integer, CarModelName TVarChar
             , CarTrailerId Integer, CarTrailerName TVarChar, CarTrailerModelId Integer, CarTrailerModelName TVarChar
             , PersonalDriverId Integer, PersonalDriverName TVarChar
             , CarJuridicalId Integer, CarJuridicalName TVarChar
             , MemberId1 Integer, MemberName1 TVarChar
             , MemberId2 Integer, MemberName2 TVarChar
             , MemberId3 Integer, MemberName3 TVarChar
             , MemberId4 Integer, MemberName4 TVarChar
             , MemberId5 Integer, MemberName5 TVarChar
             , MemberId6 Integer, MemberName6 TVarChar
             , MemberId7 Integer, MemberName7 TVarChar
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , JuricalId_car Integer
             , TotalCountBox TFloat
             , TotalWeightBox TFloat
             , BarCode TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsOd Boolean;
   DECLARE vbIsKh Boolean;
   DECLARE vbIsNik Boolean;
   DECLARE vbBranchId Integer;
   DECLARE vbMemberId_store Integer;
   DECLARE vbDescId_mov Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_TransportGoods());
     vbUserId:= lpGetUserBySession (inSession);

     vbDescId_mov := (SELECT Movement.DescId FROM Movement WHERE Movement.Id = inMovementId_Sale);

     -- пытаемся найти по продаже
     IF inMovementId_Sale <> 0 AND COALESCE (inMovementId, 0) = 0
     THEN
         inMovementId:= (SELECT MovementChildId FROM MovementLinkMovement WHERE MovementId = inMovementId_Sale AND DescId = zc_MovementLinkMovement_TransportGoods());
     END IF;

     vbMemberId_store:=  COALESCE ((SELECT Object_PersonalStore_View.MemberId
                                    FROM MovementLinkObject AS MLO_From
                                         LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                                              ON ObjectLink_Unit_Branch.ObjectId = MLO_From.ObjectId
                                                             AND ObjectLink_Unit_Branch.DescId   = zc_ObjectLink_Unit_Branch()
                                         LEFT JOIN ObjectLink AS ObjectLink_Branch_PersonalStore
                                                              ON ObjectLink_Branch_PersonalStore.ObjectId = ObjectLink_Unit_Branch.ChildObjectId
                                                             AND ObjectLink_Branch_PersonalStore.DescId   = zc_ObjectLink_Branch_PersonalStore()
                                         LEFT JOIN Object_Personal_View AS Object_PersonalStore_View ON Object_PersonalStore_View.PersonalId = ObjectLink_Branch_PersonalStore.ChildObjectId
                                    WHERE MLO_From.MovementId = inMovementId_Sale
                                      AND MLO_From.DescId     = CASE WHEN vbDescId_mov = zc_Movement_Sale() THEN zc_MovementLinkObject_From() ELSE zc_MovementLinkObject_To() END
                                    )
                                  , (SELECT ObjectLink_User_Member.ChildObjectId
                                     FROM Movement
                                          LEFT JOIN MovementLinkObject AS MovementLinkObject_User
                                                                       ON MovementLinkObject_User.MovementId = Movement.Id
                                                                      AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
                                          LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                                               ON ObjectLink_User_Member.ObjectId = MovementLinkObject_User.ObjectId
                                                              AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                                     WHERE Movement.ParentId = inMovementId_Sale AND Movement.DescId IN (zc_Movement_WeighingPartner(), zc_Movement_WeighingProduction())
                                       AND Movement.StatusId = zc_Enum_Status_Complete()
                                     LIMIT 1
                                  ));

     -- Определяем филиал
     vbBranchId = (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId);
     -- !!! для Одесса, понятно что временно!!!
     vbIsOd:= 8374 = (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId);
     -- !!! для Харькова, понятно что временно!!! )))
     vbIsKh:= 8381 = (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId);
     -- !!! для Николаева, понятно что временно!!! )))
     vbIsNik:= 8373 = (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId);


     -- если надо - создаем
     IF COALESCE (inMovementId, 0) = 0
     THEN inMovementId:= lpInsertUpdate_Movement_TransportGoods (ioId              := inMovementId
                                                               , inInvNumber       := NEXTVAL ('Movement_TransportGoods_seq') :: TVarChar
                                                               , inOperDate        := COALESCE ((SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId_Sale AND MD.DescId = zc_MovementDate_OperDatePartner())
                                                                                    , COALESCE ((SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId_Sale)
                                                                                    , inOperDate))
                                                               , inMovementId_Sale := inMovementId_Sale
                                                               , inInvNumberMark   := NULL
                                                               , inCarId           := CASE WHEN COALESCE (MLO_Car.ObjectId, 0) <> 0 THEN MLO_Car.ObjectId
                                                                                           WHEN COALESCE (tmpBranch.CarId, 0)  <> 0 THEN tmpBranch.CarId
                                                                                           ELSE CASE -- vbIsOd + Фоззі
                                                                                                     WHEN vbIsOd = TRUE AND (SELECT OL_Retail.ChildObjectId
                                                                                                                             FROM MovementLinkObject AS MLO
                                                                                                                                  LEFT JOIN ObjectLink AS OL_Juridical ON OL_Juridical.ObjectId = MLO.ObjectId AND OL_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                                                                                                                  LEFT JOIN ObjectLink AS OL_Retail ON OL_Retail.ObjectId = OL_Juridical.ChildObjectId AND OL_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                                                                                             WHERE MLO.MovementId = inMovementId_Sale AND MLO.DescId = CASE WHEN vbDescId_mov = zc_Movement_Sale() THEN zc_MovementLinkObject_To() ELSE zc_MovementLinkObject_From() END
                                                                                                                            ) IN (310854, 341640) -- Фозі + Фоззі
                                                                                                          THEN 148689 -- АЕ 12-54 СА
                                                                                                     WHEN vbIsOd = TRUE
                                                                                                          THEN 8682   -- 850-51 АВ
                                                                                                     WHEN vbIsNik = TRUE
                                                                                                          THEN 518529 -- BE 59-17 AO
                                                                                                     ELSE NULL
                                                                                                END
                                                                                      END
                                                               , inCarTrailerId    := NULL
                                                               , inPersonalDriverId:= CASE WHEN COALESCE (MLO_PersonalDriver.ObjectId,0) <> 0 THEN MLO_PersonalDriver.ObjectId
                                                                                           WHEN COALESCE (tmpBranch.PersonalDriverId,0)  <> 0 THEN tmpBranch.PersonalDriverId
                                                                                           ELSE CASE
                                                                                                     -- vbIsOd + Фоззі
                                                                                                     WHEN vbIsOd = TRUE AND (SELECT OL_Retail.ChildObjectId
                                                                                                                             FROM MovementLinkObject AS MLO
                                                                                                                                  LEFT JOIN ObjectLink AS OL_Juridical ON OL_Juridical.ObjectId = MLO.ObjectId AND OL_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                                                                                                                  LEFT JOIN ObjectLink AS OL_Retail ON OL_Retail.ObjectId = OL_Juridical.ChildObjectId AND OL_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                                                                                             WHERE MLO.MovementId = inMovementId_Sale AND MLO.DescId = CASE WHEN vbDescId_mov = zc_Movement_Sale() THEN zc_MovementLinkObject_To() ELSE zc_MovementLinkObject_From() END
                                                                                                                            ) IN (310854, 341640) -- Фозі + Фоззі
                                                                                                          THEN 343903 -- Шульгін Олексій Валерійович
                                                                                                     WHEN vbIsOd = TRUE
                                                                                                          THEN 427054 -- Строкун Артем Миколайович
                                                                                                     WHEN vbIsNik = TRUE
                                                                                                         -- THEN 149822  -- Бойченко Денис Анатолійович
                                                                                                          THEN 518520  -- Флера Сергей Владимирович
                                                                                                     ELSE NULL
                                                                                                END
                                                                                      END
                                                               , inRouteId         := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId_Sale AND MLO.DescId = zc_MovementLinkObject_Route())
                                                                 -- отримав водій/експедитор - 1
                                                               , inMemberId1       := CASE WHEN COALESCE (MLO_PersonalDriver.ObjectId,0) <> 0 THEN MLO_PersonalDriver.ObjectId
                                                                                           WHEN COALESCE (tmpBranch.Member1Id,0) <> 0 THEN tmpBranch.Member1Id
                                                                                           ELSE CASE
                                                                                                     -- vbIsOd + Фоззі
                                                                                                     WHEN vbIsOd = TRUE AND (SELECT OL_Retail.ChildObjectId
                                                                                                                             FROM MovementLinkObject AS MLO
                                                                                                                                  LEFT JOIN ObjectLink AS OL_Juridical ON OL_Juridical.ObjectId = MLO.ObjectId AND OL_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                                                                                                                  LEFT JOIN ObjectLink AS OL_Retail ON OL_Retail.ObjectId = OL_Juridical.ChildObjectId AND OL_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                                                                                             WHERE MLO.MovementId = inMovementId_Sale AND MLO.DescId = CASE WHEN vbDescId_mov = zc_Movement_Sale() THEN zc_MovementLinkObject_To() ELSE zc_MovementLinkObject_From() END
                                                                                                                            ) IN (310854, 341640) -- Фозі + Фоззі
                                                                                                          THEN 343903 -- Шульгін Олексій Валерійович
                                                                                                     WHEN vbIsOd = TRUE
                                                                                                          THEN 427054 -- Строкун Артем Миколайович
                                                                                                     WHEN vbIsNik = TRUE
                                                                                                          --THEN 149822  -- Бойченко Денис Анатолійович
                                                                                                         THEN 518520  -- Флера Сергей Владимирович
                                                                                                     ELSE NULL
                                                                                                END
                                                                                      END
                                                                 -- Бухгалтер (відповідальна особа вантажовідправника) - 2
                                                               , inMemberId2       := CASE WHEN COALESCE (tmpBranch.Member2Id,0) <> 0 THEN tmpBranch.Member2Id
                                                                                           ELSE CASE WHEN vbIsOd = TRUE
                                                                                                     THEN 7892803 -- Новаковська Наталя Віталіївна -- 418699 -- Бирдіна Оксана Євгенівна
                                                                                                WHEN vbIsNik = TRUE
                                                                                                     THEN 453450 -- Тимків Тетяна Василівна
                                                                                                     --THEN 419066 -- Глушкова Нина Николаевна  453450
                                                                                                ELSE NULL
                                                                                           END
                                                                                      END
                                                                 -- Відпуск дозволив - 3
                                                               , inMemberId3       := CASE WHEN COALESCE (tmpBranch.Member3Id,0) <> 0 THEN tmpBranch.Member3Id
                                                                                           ELSE CASE WHEN vbIsOd = TRUE
                                                                                                          THEN 7892803 -- Новаковська Наталя Віталіївна -- 418699 -- Бирдіна Оксана Євгенівна
                                                                                                     WHEN vbIsNik = TRUE
                                                                                                          THEN 453450 -- Тимків Тетяна Василівна
                                                                                                          --THEN 419066 -- Глушкова Нина Николаевна
                                                                                                     ELSE NULL
                                                                                                END
                                                                                      END
                                                                 -- Здав (відповідальна особа вантажовідправника) - 4
                                                               , inMemberId4       := CASE WHEN COALESCE (tmpBranch.Member4Id,0) <> 0 THEN tmpBranch.Member4Id
                                                                                           ELSE CASE WHEN vbIsKh = TRUE
                                                                                                          THEN 301480 -- Самохін Володимир Іванович кладовщик
                                                                                                     WHEN vbIsNik = TRUE
                                                                                                          THEN 453450 -- Тимків Тетяна Василівна
                                                                                                          --THEN 419066 -- Глушкова Нина Николаевна
                                                                                                     WHEN vbMemberId_store <> 0
                                                                                                          THEN vbMemberId_store
                                                                                                     ELSE NULL
                                                                                                END
                                                                                      END
                                                                 -- Прийняв водій/експедитор - 1
                                                               , inMemberId5       := NULL
                                                                 -- Здав водій/експедитор - пусто ИЛИ 1
                                                               , inMemberId6       := NULL
                                                                 --  Прийняв (відповідальна особа вантажоодержувача) - пусто
                                                               , inMemberId7       := NULL
                                                                 --
                                                               , inUserId          := vbUserId
                                                                )
                          FROM (SELECT vbBranchId AS BranchId) AS tmp
                               LEFT JOIN gpSelect_Object_Branch (zfCalc_UserAdmin()) AS tmpBranch ON tmpBranch.id = tmp.BranchId
                               LEFT JOIN Movement ON Movement.Id = inMovementId_Sale AND COALESCE (inMovementId, 0) = 0
                               LEFT JOIN Movement AS Movement_child ON Movement_child.ParentId = Movement.Id
                                                                   AND Movement_child.DescId   = zc_Movement_WeighingPartner()
                                                                   AND 1=0
                               LEFT JOIN MovementLinkMovement AS MLM_Transport
                                                              ON MLM_Transport.MovementId = Movement_child.Id
                                                             AND MLM_Transport.DescId     = zc_MovementLinkMovement_Transport()
                                                             AND 1=0
                               LEFT JOIN MovementLinkObject AS MLO_Car
                                                            ON MLO_Car.MovementId = MLM_Transport.MovementChildId
                                                           AND MLO_Car.DescId = zc_MovementLinkObject_Car()
                                                           AND 1=0
                               LEFT JOIN MovementLinkObject AS MLO_PersonalDriver
                                                            ON MLO_PersonalDriver.MovementId = MLM_Transport.MovementChildId
                                                           AND MLO_PersonalDriver.DescId     = zc_MovementLinkObject_PersonalDriver()
                                                           AND 1=0
                        ;
     END IF;


     -- Результат
     RETURN QUERY
       SELECT
             Movement.Id
           , zfFormat_BarCode (zc_BarCodePref_Movement(), Movement.Id):: TVarChar AS IdBarCode
           , Movement.InvNumber
           , Movement.OperDate


           , MovementString_InvNumberMark.ValueData  AS InvNumberMark

           , Movement_Sale.Id        AS MovementId_Sale
           , Movement_Sale.InvNumber AS InvNumber_Sale
           , Movement_Sale.OperDate  AS OperDate_Sale

           , Object_Route.Id                  AS RouteId
           , Object_Route.ValueData           AS RouteName
           , Object_Car.Id                    AS CarId
           , Object_Car.ValueData             AS CarName
           , Object_CarModel.Id               AS CarModelId
           , (COALESCE (Object_CarModel.ValueData,'') || COALESCE (' ' || Object_CarType.ValueData, '') ) ::TVarChar AS CarModelName
           , Object_CarTrailer.Id             AS CarTrailerId
           , Object_CarTrailer.ValueData      AS CarTrailerName
           , Object_CarTrailerModel.Id        AS CarTrailerModelId
           , Object_CarTrailerModel.ValueData AS CarTrailerModelName
           , Object_PersonalDriver.Id         AS PersonalDriverId
           , Object_PersonalDriver.ValueData  AS PersonalDriverName

           , COALESCE (Object_Juridical_From.Id, Object_CarJuridical.Id)                AS CarJuridicalId
           , COALESCE (Object_Juridical_From.ValueData, Object_CarJuridical.ValueData)  AS CarJuridicalName

           , CASE WHEN TRIM (Object_Member1.ValueData) = '' THEN 0 ELSE Object_Member1.Id END :: Integer AS MemberId1
           , Object_Member1.ValueData AS MemberName1
           , CASE WHEN TRIM (Object_Member2.ValueData) = '' THEN 0 ELSE Object_Member2.Id END :: Integer AS MemberId2
           , Object_Member2.ValueData AS MemberName2
           , CASE WHEN TRIM (Object_Member3.ValueData) = '' THEN 0 ELSE Object_Member3.Id END :: Integer AS MemberId3
           , Object_Member3.ValueData AS MemberName3
           , CASE WHEN TRIM (Object_Member4.ValueData) = '' THEN 0 ELSE Object_Member4.Id END :: Integer AS MemberId4
           , Object_Member4.ValueData AS MemberName4
           , CASE WHEN TRIM (Object_Member5.ValueData) = '' THEN 0 ELSE Object_Member5.Id END :: Integer AS MemberId5
           , Object_Member5.ValueData AS MemberName5
           , CASE WHEN TRIM (Object_Member6.ValueData) = '' THEN 0 ELSE Object_Member6.Id END :: Integer AS MemberId6
           , Object_Member6.ValueData AS MemberName6
           , CASE WHEN TRIM (Object_Member7.ValueData) = '' THEN 0 ELSE Object_Member7.Id END :: Integer AS MemberId7
           , Object_Member7.ValueData AS MemberName7

           , Object_From.Id           AS FromId
           , Object_From.ValueData    AS FromName
           , Object_To.Id             AS ToId
           , Object_To.ValueData      AS ToName

           , MI_Transport.ObjectId AS JuricalId_car

           , 0  :: TFloat   AS TotalCountBox
           , 0  :: TFloat   AS TotalWeightBox
           , (zfFormat_BarCode (zc_BarCodePref_Movement(), Movement_Transport.Id) || '0')  :: TVarChar AS BarCode -- ш/к путевого листа

       FROM Movement
            LEFT JOIN MovementString AS MovementString_InvNumberMark
                                     ON MovementString_InvNumberMark.MovementId =  Movement.Id
                                    AND MovementString_InvNumberMark.DescId = zc_MovementString_InvNumberMark()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                         ON MovementLinkObject_Route.MovementId = Movement.Id
                                        AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = MovementLinkObject_Route.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Car
                                         ON MovementLinkObject_Car.MovementId = Movement.Id
                                        AND MovementLinkObject_Car.DescId = zc_MovementLinkObject_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = MovementLinkObject_Car.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel                                            -- авто
                                 ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN ObjectLink AS ObjectLink_CarExternal_CarModel                                    -- авто стороннее
                                 ON ObjectLink_CarExternal_CarModel.ObjectId = Object_Car.Id
                                AND ObjectLink_CarExternal_CarModel.DescId = zc_ObjectLink_CarExternal_CarModel()

            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = COALESCE(ObjectLink_Car_CarModel.ChildObjectId, ObjectLink_CarExternal_CarModel.ChildObjectId)

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                 ON ObjectLink_Car_CarType.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_CarType.DescId IN (zc_ObjectLink_Car_CarType(), zc_ObjectLink_CarExternal_CarType())
            LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId


            LEFT JOIN MovementLinkObject AS MovementLinkObject_CarTrailer
                                         ON MovementLinkObject_CarTrailer.MovementId = Movement.Id
                                        AND MovementLinkObject_CarTrailer.DescId = zc_MovementLinkObject_CarTrailer()
            LEFT JOIN Object AS Object_CarTrailer ON Object_CarTrailer.Id = MovementLinkObject_CarTrailer.ObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_CarTrailer_CarModel ON ObjectLink_CarTrailer_CarModel.ObjectId = Object_CarTrailer.Id
                                                                  AND ObjectLink_CarTrailer_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarTrailerModel ON Object_CarTrailerModel.Id = ObjectLink_CarTrailer_CarModel.ChildObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver
                                         ON MovementLinkObject_PersonalDriver.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
            LEFT JOIN Object AS Object_PersonalDriver ON Object_PersonalDriver.Id = MovementLinkObject_PersonalDriver.ObjectId

--          определяем юр.лицо
            LEFT JOIN ObjectLink AS ObjectLink_Car_Juridical                                                      -- юр.лицо авто
                                 ON ObjectLink_Car_Juridical.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_Juridical.DescId = zc_ObjectLink_Car_Juridical()
            LEFT JOIN ObjectLink AS ObjectLink_CarExternal_Juridical                                               -- юр.лицо авто стороннее
                                 ON ObjectLink_CarExternal_Juridical.ObjectId = Object_Car.Id
                                AND ObjectLink_CarExternal_Juridical.DescId = zc_ObjectLink_CarExternal_Juridical()

            LEFT JOIN ObjectLink AS ObjectLink_Car_Unit                                                           -- подразделение авто
                                 ON ObjectLink_Car_Unit.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_Unit.DescId = zc_ObjectLink_Car_Unit()
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical                                                     -- юр.лицо подразделения авто
                                 ON ObjectLink_Unit_Juridical.ObjectId =  ObjectLink_Car_Unit.ChildObjectId
                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Contract                                                      --  подразделение  Договор (перевыставление затрат)
                                 ON ObjectLink_Unit_Contract.ObjectId = ObjectLink_Car_Unit.ChildObjectId
                                AND ObjectLink_Unit_Contract.DescId = zc_ObjectLink_Unit_Contract()
            LEFT JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                 ON ObjectLink_Contract_Juridical.ObjectId = ObjectLink_Unit_Contract.ChildObjectId
                                AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()

            LEFT JOIN Object AS Object_CarJuridical ON Object_CarJuridical.Id = COALESCE(ObjectLink_Car_Juridical.ChildObjectId, COALESCE(ObjectLink_CarExternal_Juridical.ChildObjectId, COALESCE(ObjectLink_Unit_Juridical.ChildObjectId, COALESCE(ObjectLink_Contract_Juridical.ChildObjectId,0))) )
--

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member1
                                         ON MovementLinkObject_Member1.MovementId = Movement.Id
                                        AND MovementLinkObject_Member1.DescId = zc_MovementLinkObject_Member1()
            LEFT JOIN Object AS Object_Member1 ON Object_Member1.Id = MovementLinkObject_Member1.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member2
                                         ON MovementLinkObject_Member2.MovementId = Movement.Id
                                        AND MovementLinkObject_Member2.DescId = zc_MovementLinkObject_Member2()
            LEFT JOIN Object AS Object_Member2 ON Object_Member2.Id = MovementLinkObject_Member2.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member3
                                         ON MovementLinkObject_Member3.MovementId = Movement.Id
                                        AND MovementLinkObject_Member3.DescId = zc_MovementLinkObject_Member3()
            LEFT JOIN Object AS Object_Member3 ON Object_Member3.Id = CASE WHEN vbIsOd = TRUE AND MovementLinkObject_Member3.ObjectId IS NULL
                                                                                THEN 7892803 -- Новаковська Наталя Віталіївна -- 418699 -- Бирдіна Оксана Євгенівна
                                                                           WHEN vbIsNik = TRUE AND MovementLinkObject_Member3.ObjectId IS NULL
                                                                                THEN 453450 -- Тимків Тетяна Василівна
                                                                           ELSE MovementLinkObject_Member3.ObjectId
                                                                      END
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member4
                                         ON MovementLinkObject_Member4.MovementId = Movement.Id
                                        AND MovementLinkObject_Member4.DescId = zc_MovementLinkObject_Member4()
            LEFT JOIN Object AS Object_Member4 ON Object_Member4.Id = MovementLinkObject_Member4.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member5
                                         ON MovementLinkObject_Member5.MovementId = Movement.Id
                                        AND MovementLinkObject_Member5.DescId = zc_MovementLinkObject_Member5()
            LEFT JOIN Object AS Object_Member5 ON Object_Member5.Id = MovementLinkObject_Member5.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member6
                                         ON MovementLinkObject_Member6.MovementId = Movement.Id
                                        AND MovementLinkObject_Member6.DescId = zc_MovementLinkObject_Member6()
            LEFT JOIN Object AS Object_Member6 ON Object_Member6.Id = MovementLinkObject_Member6.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Member7
                                         ON MovementLinkObject_Member7.MovementId = Movement.Id
                                        AND MovementLinkObject_Member7.DescId = zc_MovementLinkObject_Member7()
            LEFT JOIN Object AS Object_Member7 ON Object_Member7.Id = MovementLinkObject_Member7.ObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_TransportGoods
                                           ON MovementLinkMovement_TransportGoods.MovementChildId = Movement.Id
                                          AND MovementLinkMovement_TransportGoods.DescId = zc_MovementLinkMovement_TransportGoods()

            LEFT JOIN Movement AS Movement_Sale ON Movement_Sale.Id = MovementLinkMovement_TransportGoods.MovementId
                                               AND Movement_Sale.StatusId = zc_Enum_Status_Complete()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = MovementLinkMovement_TransportGoods.MovementId
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            -- !!!Склад Реализации!!!
            LEFT JOIN Object AS Object_From ON Object_From.Id = CASE WHEN Movement_Sale.DescId = zc_Movement_TransferDebtOut() THEN 8459 ELSE MovementLinkObject_From.ObjectId END 

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = MovementLinkMovement_TransportGoods.MovementId
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

            LEFT JOIN MovementLinkMovement AS MLM_Transport
                                           ON MLM_Transport.MovementId = Movement.Id
                                          AND MLM_Transport.DescId     = zc_MovementLinkMovement_Transport()

            LEFT JOIN Movement AS Movement_Transport ON Movement_Transport.Id = MLM_Transport.MovementChildId
            LEFT JOIN MovementItem AS MI_Transport
                                   ON MI_Transport.MovementId = Movement_Transport.Id
                                  AND MI_Transport.DescId = zc_MI_Master()
                                  AND MI_Transport.isErased = FALSE
                                  AND Movement_Transport.DescId = zc_Movement_TransportService()
  
            --если возврат   Вантажовідправник - клиент
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = Object_From.Id
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                AND vbDescId_mov = zc_Movement_ReturnIn()
            LEFT JOIN Object AS Object_Juridical_From ON Object_Juridical_From.Id = ObjectLink_Partner_Juridical.ChildObjectId
       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_TransportGoods()
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_TransportGoods (Integer, Integer, TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 26.01.16         * add vbBranchId
 02.11.15         * add vbIsKh, Самохін Володимир Іванович кладовщик
 28.03.15                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_TransportGoods22 (inMovementId:= 1, inMovementId_Sale:= 2, inOperDate:= '01.01.2015', inSession:= zfCalc_UserAdmin())

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_TransportGoods22 (ioId:= 149691, inInvNumber:= '1', inOperDate:= '01.10.2013 3:00:00',............, inSession:= '2')
--select * from gpGet_Movement_TransportGoods(inMovementId := 24561040 , inMovementId_Sale := 24559843 , inOperDate := ('17.02.2023')::TDateTime ,  inSession := '9457');
