-- View: PrintForms_View

-- DROP VIEW IF EXISTS PrintForms_View CASCADE;

CREATE OR REPLACE VIEW PrintForms_View
AS
      SELECT
             zc_Movement_Sale()                         AS DescId
           , CAST ('Sale' AS TVarChar)                  AS ReportType
           , CAST ('01.01.2000' AS TDateTime)           AS StartDate
           , CAST ('01.01.2200' AS TDateTime)           AS EndDate
           , CAST (0 AS INTEGER)                        AS JuridicalId
           , zc_Enum_PaidKind_FirstForm()               AS PaidKindId --б/н
           , CAST ('PrintMovement_Sale1' AS TVarChar)   AS PrintFormName
      UNION
      SELECT
             zc_Movement_Sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (0 AS INTEGER)
           ,  zc_Enum_PaidKind_SecondForm()             AS PaidKindId --нал
           , CAST ('PrintMovement_Sale2' AS TVarChar)
      UNION
-- признак isDiscountPrice = True - печатать цену со скидкой
      SELECT
             zc_Movement_Sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale2DiscountPrice' AS TVarChar)
      FROM Object AS Object_Juridical
        JOIN ObjectBoolean AS ObjectBoolean_isDiscountPrice
                           ON ObjectBoolean_isDiscountPrice.ObjectId = Object_Juridical.Id
                          AND ObjectBoolean_isDiscountPrice.DescId = zc_ObjectBoolean_Juridical_isDiscountPrice()
                          AND ObjectBoolean_isDiscountPrice.ValueData = TRUE
      WHERE Object_Juridical.DescId = zc_Object_Juridical()
      UNION
-- признак isPriceWithVAT = True - печатать цену с НДС
      SELECT
             zc_Movement_Sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale2PriceWithVAT' AS TVarChar)
      FROM Object AS Object_Juridical
        JOIN ObjectBoolean AS ObjectBoolean_isPriceWithVAT
                           ON ObjectBoolean_isPriceWithVAT.ObjectId = Object_Juridical.Id
                          AND ObjectBoolean_isPriceWithVAT.DescId = zc_ObjectBoolean_Juridical_isPriceWithVAT()
                          AND ObjectBoolean_isPriceWithVAT.ValueData = TRUE
        LEFT JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
      WHERE Object_Juridical.DescId = zc_Object_Juridical()
        AND OH_JuridicalDetails.OKPO NOT IN ('2902403938')
      UNION
-- признак isPriceWithVAT = True - печатать цену с НДС
      SELECT
             zc_Movement_Sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale2PriceWithVAT' AS TVarChar)
      FROM Object AS Object_Juridical
        LEFT JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
      WHERE Object_Juridical.DescId = zc_Object_Juridical()
        AND OH_JuridicalDetails.OKPO IN ('02541349')

      UNION
-- Счет
      SELECT
             zc_Movement_Sale()                         AS DescId
           , CAST ('Bill' AS TVarChar)                  AS ReportType
           , CAST ('01.01.2000' AS TDateTime)           AS StartDate
           , CAST ('01.01.2200' AS TDateTime)           AS EndDate
           , CAST (0 AS INTEGER)                        AS JuridicalId
           , zc_Enum_PaidKind_FirstForm()               AS PaidKindId --б/н
           , CAST ('PrintMovement_Bill' AS TVarChar)    AS PrintFormName
      UNION
      SELECT
             zc_Movement_Sale()                         AS DescId
           , CAST ('Bill' AS TVarChar)                  AS ReportType
           , CAST ('01.01.2000' AS TDateTime)           AS StartDate
           , CAST ('01.01.2200' AS TDateTime)           AS EndDate
           , CAST (0 AS INTEGER)                        AS JuridicalId
           , zc_Enum_PaidKind_SecondForm()              AS PaidKindId --н
           , CAST ('PrintMovement_Bill' AS TVarChar)    AS PrintFormName

      UNION
      SELECT
             zc_Movement_Sale()
           , CAST ('Bill' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)                         -- ж/д
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Bill01074874' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('01074874','23193668','01074791','25774961','01074302','01074064',
                                        '01073981','26139824','01074874','24755803','04791599','01073946','01074741','25927436')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()

      UNION
      SELECT
             zc_Movement_Sale()                         AS DescId
           , CAST ('Bill' AS TVarChar)                  AS ReportType
           , CAST ('01.01.2000' AS TDateTime)           AS StartDate
           , CAST ('01.01.2200' AS TDateTime)           AS EndDate
           , CAST (Object_Juridical.Id AS INTEGER)      AS JuridicalId
           , zc_Enum_PaidKind_FirstForm()               AS PaidKindId --б/н
           , CAST ('PrintMovement_Bill' AS TVarChar)    AS PrintFormName
      FROM Object AS Object_Juridical
        JOIN ObjectBoolean AS ObjectBoolean_isPriceWithVAT
                           ON ObjectBoolean_isPriceWithVAT.ObjectId = Object_Juridical.Id
                          AND ObjectBoolean_isPriceWithVAT.DescId = zc_ObjectBoolean_Juridical_isPriceWithVAT()
                          AND ObjectBoolean_isPriceWithVAT.ValueData = FALSE
      UNION
      SELECT
             zc_Movement_Sale()                         AS DescId
           , CAST ('Bill' AS TVarChar)                  AS ReportType
           , CAST ('01.01.2000' AS TDateTime)           AS StartDate
           , CAST ('01.01.2200' AS TDateTime)           AS EndDate
           , CAST (Object_Juridical.Id AS INTEGER)      AS JuridicalId
           , zc_Enum_PaidKind_SecondForm()              AS PaidKindId --н
           , CAST ('PrintMovement_Bill' AS TVarChar)    AS PrintFormName
      FROM Object AS Object_Juridical
        JOIN ObjectBoolean AS ObjectBoolean_isPriceWithVAT
                           ON ObjectBoolean_isPriceWithVAT.ObjectId = Object_Juridical.Id
                          AND ObjectBoolean_isPriceWithVAT.DescId = zc_ObjectBoolean_Juridical_isPriceWithVAT()
                          AND ObjectBoolean_isPriceWithVAT.ValueData = FALSE

      UNION

      SELECT
             zc_Movement_Sale()                         AS DescId
           , CAST ('Bill' AS TVarChar)                  AS ReportType
           , CAST ('01.01.2000' AS TDateTime)           AS StartDate
           , CAST ('01.01.2200' AS TDateTime)           AS EndDate
           , CAST (Object_Juridical.Id AS INTEGER)      AS JuridicalId
           , zc_Enum_PaidKind_FirstForm()               AS PaidKindId --б/н
           , CAST ('PrintMovement_Bill_WithVAT' AS TVarChar)   AS PrintFormName
      FROM Object AS Object_Juridical
        JOIN ObjectBoolean AS ObjectBoolean_isPriceWithVAT
                           ON ObjectBoolean_isPriceWithVAT.ObjectId = Object_Juridical.Id
                          AND ObjectBoolean_isPriceWithVAT.DescId = zc_ObjectBoolean_Juridical_isPriceWithVAT()
                          AND ObjectBoolean_isPriceWithVAT.ValueData = TRUE
        LEFT JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
      WHERE Object_Juridical.DescId = zc_Object_Juridical()
        AND OH_JuridicalDetails.OKPO NOT IN  ('01074874','23193668','01074791','25774961','01074302','01074064',
                                             '01073981','26139824','01074874','24755803','04791599','01073946','01074741','25927436')
      UNION
      SELECT
             zc_Movement_Sale()                         AS DescId
           , CAST ('Bill' AS TVarChar)                  AS ReportType
           , CAST ('01.01.2000' AS TDateTime)           AS StartDate
           , CAST ('01.01.2200' AS TDateTime)           AS EndDate
           , CAST (Object_Juridical.Id AS INTEGER)      AS JuridicalId
           , zc_Enum_PaidKind_SecondForm()              AS PaidKindId --б/н
           , CAST ('PrintMovement_Bill_WithVAT' AS TVarChar)   AS PrintFormName
      FROM Object AS Object_Juridical
        JOIN ObjectBoolean AS ObjectBoolean_isPriceWithVAT
                           ON ObjectBoolean_isPriceWithVAT.ObjectId = Object_Juridical.Id
                          AND ObjectBoolean_isPriceWithVAT.DescId = zc_ObjectBoolean_Juridical_isPriceWithVAT()
                          AND ObjectBoolean_isPriceWithVAT.ValueData = TRUE
        LEFT JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
      WHERE Object_Juridical.DescId = zc_Object_Juridical()
        AND OH_JuridicalDetails.OKPO NOT IN  ('01074874','23193668','01074791','25774961','01074302','01074064',
                                             '01073981','26139824','01074874','24755803','04791599','01073946','01074741','25927436')
      UNION


--если с определенной даты появится новая форма добавляем запись, а у предидущей уменьшаем EndDate до StartDate этой записи

-- добавляем записи для покупаетелей с нестандартными формами накладных
-- с одной формой на ОКПО
      SELECT
             zc_Movement_Sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)                         -- покупатели с отдельными формами
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale'||OH_JuridicalDetails.OKPO AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('30487219','32049199')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()

      UNION
      -- Фоззі-Фуд ТОВ + СІЛЬПО-ФУД
      SELECT
             zc_Movement_Sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale32294926' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('32294926', '40720198', '32294897', '42751590', '41028986'
                                        -- Експансія ТОВ ...
                                      , '32294905', '35278624', '38939423', '38183389', '34902541', '36577999'
                                        -- Ексопт ТОВ
                                      , '44708897'
                                       )
      WHERE Object_Juridical.DescId = zc_Object_Juridical()

     UNION
      -- ЕПІЦЕНТР К ТОВ, Рідо Груп, Легіон 2015 ТОВ, Арітейл, Понтем Плюс
      SELECT
             zc_Movement_Sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale32490244' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('32490244', '41744911', '39775097', '41135005', '30728887', '41609092'
                                      , '40075815' --  "укрзалізниця АТ" 
                                       )
      WHERE Object_Juridical.DescId = zc_Object_Juridical()

     UNION
      -- ЧСПМ ЛОГІСТИК ТОВ 41750857
      SELECT
             zc_Movement_Sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale41750857' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('41750857')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()

     UNION
      -- Ашан Україна Гіпермаркет ТОВ + РІАЛ ІСТЕЙТ Ф.К.А.У.
      SELECT
             zc_Movement_Sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale35442481' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('35442481', '34431547')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()

     UNION
      -- Амстор Торгiвельний будинок ТОВ + Амстор Трейд
      SELECT
             zc_Movement_Sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale32516492' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('32516492', '39135315', '39622918')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()

     UNION
      -- Adventis + Billa + Kray
      SELECT
             zc_Movement_Sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale35275230' AS TVarChar)
      FROM Object AS Object_Juridical
           LEFT JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
           LEFT JOIN ObjectLink AS ObjectLink_Retail
                                ON ObjectLink_Retail.ObjectId = Object_Juridical.Id
                               AND ObjectLink_Retail.DescId = zc_ObjectLink_Juridical_Retail()
      WHERE Object_Juridical.DescId = zc_Object_Juridical()
        AND (OH_JuridicalDetails.OKPO IN ('35275230','25288083','35231874') -- '39143745' перенесли в др.группу ритейл
             OR (ObjectLink_Retail.ChildObjectId IN (310862) -- Рост Харьков
                  AND OH_JuridicalDetails.OKPO <> '43094673')      --другая печать   ДЛК "ПІЛОТ"
            )

     UNION
      -- Omega+РТЦ ТОВ(Варус)
      SELECT
             zc_Movement_Sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale30982361' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('30982361', '33184262')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()

     UNION
      -- Таврія
      SELECT
             zc_Movement_Sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale31929492' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('31929492', '32334104', '19202597')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()

     UNION
      -- Furshet
      SELECT
             zc_Movement_Sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale37910513' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('37910513','37910542')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()

     UNION
      -- ЖД
      SELECT
             zc_Movement_Sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale01074874' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('01074874','23193668'
                                      , '01074791','25774961','01074302','01074064','01073981','26139824'
                                      , '01074874','24755803','04791599','01073946','01074741','25927436'
                                       )
      WHERE Object_Juridical.DescId = zc_Object_Juridical()

     UNION
      -- Укрзалізниця АТ
      SELECT
             zc_Movement_Sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale43112236' AS TVarChar)
      FROM Object AS Object_Juridical
           JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
                   AND OH_JuridicalDetails.OKPO IN ('43112236')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()

     UNION
      -- FM
      SELECT
             zc_Movement_Sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale36387249' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('36387249', '36387233', '38916558', '40982829'
                                   -- , '37077262' -- Атік Агро ТОВ  ОКПО 37077262
                                       )
      WHERE Object_Juridical.DescId = zc_Object_Juridical()

     UNION
      -- Objora
      SELECT
             zc_Movement_Sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale22447463' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('22447463', '37223357', '37223320')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()

     UNION
      -- Новус
      SELECT
             zc_Movement_Sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale36003603' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('36003603')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()

     UNION
      -- Лабр+Твич+Финест+Джуна+Группа Ритейлу Украины + ТОВ Нордон + Амиата + Легион-2015 + ФРЕЯ 2017 ТОВ + Левайс
      SELECT
             zc_Movement_Sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale39118745' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('39118745','39117631', '39118572', '39143745' -- ? + Фінєст + ? + ? + ?
                                      , '39118195' -- Мегамаркет
                                      , '39117799' -- Нордон
                                      , '41805811' -- Гловер
                                      , '34465801' -- ТЕРКАП
                                      , '45293717' -- був Теркап-став Монблан
                                      , '40145541' -- Амиата
                                      --, '39775097' -- Легион-2015
                                      , '41299013' -- Ф.К.С. ТОВ
                                      , '41360805' -- ФРЕЯ 2017 ТОВ
                                      , '41201250' -- Левайс
                                      , '41200660' -- Релайз
                                      , '45268675' -- ГЛОРІ МІЛ ТОВ
                                      , '42599711' -- Пангеон
                                      , '44588869' -- Бунар
                                      --, '32490244' -- ЕПІЦЕНТР К ТОВ
                                      --, '41744911' -- РИДО ГРУП
                                      , '42668161' -- Стало Трейдап
                                      , '44608319' -- ОЛІВІЯ ТРЕНД
                                      , '42465240' -- новый "Сафлора"
                                      , '43233918' -- на нового клиента Хотей 43233918
                                      , '45041508' --  новий ОКПО 45041508
                                      , '45142498' -- на нового клиента Хотей 43233918
                                      , '44915740' -- Нове юр.лице Корвус
                                       )  -- добвавили из др.группу ритейл
      WHERE Object_Juridical.DescId = zc_Object_Juridical()

     UNION
      -- Сидоров 2902403938
      SELECT
             zc_Movement_Sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.06.2017' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale2902403938' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('2902403938')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()

     UNION
      -- Восторг 32437180
      SELECT
             zc_Movement_Sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale32437180' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('32437180')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()

     UNION
      --   ДЛК "ПІЛОТ"
      SELECT
             zc_Movement_Sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale43094673' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('43094673')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()


     UNION
      --   "Казенне підприємство Морська пошуково-рятувальна служба" 
      SELECT
             zc_Movement_Sale()
           , CAST ('Sale' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_Sale38017026' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('38017026')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()


      UNION
      -- налоговая
      SELECT
             zc_Movement_Sale()
           , CAST ('Tax' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('30.11.2014' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_Tax' AS TVarChar)
      UNION
      -- налоговая c 01.12.2014
      SELECT
             zc_Movement_Sale()
           , CAST ('Tax' AS TVarChar)
           , CAST ('01.12.2014' AS TDateTime)
           , CAST ('31.12.2014' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_Tax1214' AS TVarChar)
      UNION
--налоговая c 01.01.2015
      SELECT
             zc_Movement_Sale()
           , CAST ('Tax' AS TVarChar)
           , CAST ('01.01.2015' AS TDateTime)
           , CAST ('31.03.2016' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_Tax0115' AS TVarChar)
      UNION
--налоговая c 01.04.2016
      SELECT
             zc_Movement_Sale()
           , CAST ('Tax' AS TVarChar)
           , CAST ('01.04.2016' AS TDateTime)
           , CAST ('28.02.2017' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_Tax0416' AS TVarChar)
      UNION
--налоговая c 01.03.2017
      SELECT
             zc_Movement_Sale()
           , CAST ('Tax' AS TVarChar)
           , CAST ('01.03.2017' AS TDateTime)
           , CAST ('30.11.2018' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_Tax0317' AS TVarChar)
      UNION
--налоговая c 01.12.2018
      SELECT
             zc_Movement_Sale()
           , CAST ('Tax' AS TVarChar)
           , CAST ('01.12.2018' AS TDateTime)
           , CAST ('28.02.2021' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_Tax1218' AS TVarChar)
      UNION
--налоговая c 01.03.2021
      SELECT
             zc_Movement_Sale()
           , CAST ('Tax' AS TVarChar)
           , CAST ('01.03.2021' AS TDateTime)
           , CAST ('15.03.2021' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_Tax0321' AS TVarChar)
      UNION
--налоговая c 16.03.2021
      SELECT
             zc_Movement_Sale()
           , CAST ('Tax' AS TVarChar)
           , CAST ('16.03.2021' AS TDateTime)
           , CAST ('16.02.2022' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_Tax160321' AS TVarChar)

      UNION
--налоговая c 17.02.2022
      SELECT
             zc_Movement_Sale()
           , CAST ('Tax' AS TVarChar)
           , CAST ('17.02.2022' AS TDateTime)
           , CAST ('31.03.2023' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_Tax170222' AS TVarChar)
      UNION
--налоговая c 01.04.2023
      SELECT
             zc_Movement_Sale()
           , CAST ('Tax' AS TVarChar)
           , CAST ('01.04.2023' AS TDateTime)
           , CAST ('31.07.2023' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_Tax010423' AS TVarChar)
      UNION
--налоговая c 01.08.2023
      SELECT
             zc_Movement_Sale()
           , CAST ('Tax' AS TVarChar)
           , CAST ('01.08.2023' AS TDateTime)
           , CAST ('30.09.2024' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_Tax010823' AS TVarChar)
      UNION
--налоговая c 01.10.2024
      SELECT
             zc_Movement_Sale()
           , CAST ('Tax' AS TVarChar)
           , CAST ('01.10.2024' AS TDateTime)
           , CAST ('01.01.2214' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_Tax011024' AS TVarChar)
      UNION
--коррект
      SELECT
             zc_movement_TaxCorrective()
           , CAST ('TaxCorrective' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('30.11.2014' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_TaxCorrective' AS TVarChar)
      UNION
--коррект  c 01.12.2014
      SELECT
             zc_movement_TaxCorrective()
           , CAST ('TaxCorrective' AS TVarChar)
           , CAST ('01.12.2014' AS TDateTime)
           , CAST ('31.12.2014' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_TaxCorrective1214' AS TVarChar)
      UNION
--коррект  c 01.01.2015
      SELECT
             zc_movement_TaxCorrective()
           , CAST ('TaxCorrective' AS TVarChar)
           , CAST ('01.01.2015' AS TDateTime)
           , CAST ('31.03.2016' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_TaxCorrective0115' AS TVarChar)

      UNION
--коррект  c 01.04.2016
      SELECT
             zc_movement_TaxCorrective()
           , CAST ('TaxCorrective' AS TVarChar)
           , CAST ('01.04.2016' AS TDateTime)
           , CAST ('28.02.2017' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_TaxCorrective0416' AS TVarChar)
      UNION
--коррект  c 01.03.2017
      SELECT
             zc_movement_TaxCorrective()
           , CAST ('TaxCorrective' AS TVarChar)
           , CAST ('01.03.2017' AS TDateTime)
           , CAST ('30.11.2018' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_TaxCorrective0317' AS TVarChar)
      UNION
--коррект  c 01.12.2018
      SELECT
             zc_movement_TaxCorrective()
           , CAST ('TaxCorrective' AS TVarChar)
           , CAST ('01.12.2018' AS TDateTime)
           , CAST ('28.02.2021' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_TaxCorrective1218' AS TVarChar)
      UNION
--коррект  c 01.03.2021
      SELECT
             zc_movement_TaxCorrective()
           , CAST ('TaxCorrective' AS TVarChar)
           , CAST ('01.03.2021' AS TDateTime)
           , CAST ('15.03.2021' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_TaxCorrective0321' AS TVarChar)
      UNION
--коррект  c 16.03.2021
      SELECT
             zc_movement_TaxCorrective()
           , CAST ('TaxCorrective' AS TVarChar)
           , CAST ('16.03.2021' AS TDateTime)
           , CAST ('16.02.2022' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_TaxCorrective160321' AS TVarChar)
      UNION
--коррект  c 17.02.2022
      SELECT
             zc_movement_TaxCorrective()
           , CAST ('TaxCorrective' AS TVarChar)
           , CAST ('17.02.2022' AS TDateTime)
           , CAST ('31.03.2023' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_TaxCorrective170222' AS TVarChar)
      UNION
--коррект  c 01.04.2023
      SELECT
             zc_movement_TaxCorrective()
           , CAST ('TaxCorrective' AS TVarChar)
           , CAST ('01.04.2023' AS TDateTime)
           , CAST ('31.07.2023' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_TaxCorrective010423' AS TVarChar)
      UNION
--коррект  c 01.08.2023
      SELECT
             zc_movement_TaxCorrective()
           , CAST ('TaxCorrective' AS TVarChar)
           , CAST ('01.08.2023' AS TDateTime)
           , CAST ('30.09.2024' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_TaxCorrective010823' AS TVarChar)
      UNION
--коррект  c 01.10.2024
      SELECT
             zc_movement_TaxCorrective()
           , CAST ('TaxCorrective' AS TVarChar)
           , CAST ('01.10.2024' AS TDateTime)
           , CAST ('01.01.2214' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_TaxCorrective011024' AS TVarChar)

/*
-- Новая форма налоговой
      UNION
      SELECT
             zc_Movement_Sale()
           , CAST ('SaleTax' AS TVarChar)
           , CAST ('10.02.2014' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_SaleTax_2014' AS TVarChar)
*/
-- корректировка цены - стандарт
      UNION
      SELECT
             zc_Movement_PriceCorrective()
           , CAST ('PriceCorrective' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_ReturnIn' AS TVarChar)
      UNION
-- Ashan + РІАЛ ІСТЕЙТ Ф.К.А.У.
      SELECT
             zc_Movement_PriceCorrective()
           , CAST ('PriceCorrective' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_PriceCorrective35442481' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('35442481', '34431547')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()
      UNION
-- Metro - PriceCorrective
      SELECT
             zc_Movement_PriceCorrective()
           , CAST ('PriceCorrective' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_PriceCorrective32049199' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('32049199')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()


-- возвраты от пок стандарт
      UNION
      SELECT
             zc_movement_returnin()
           , CAST ('ReturnIn' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_ReturnIn' AS TVarChar)

      /*UNION
-- Metro - ReturnIn
      SELECT
             zc_movement_returnin()
           , CAST ('ReturnIn' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_ReturnIn32049199' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('32049199')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()*/

      UNION
-- Ashan
      SELECT
             zc_movement_returnin()
           , CAST ('ReturnIn' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_ReturnIn35442481' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('35442481')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()

      UNION
-- Amstor
      SELECT
             zc_movement_returnin()
           , CAST ('ReturnIn' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , zc_Enum_PaidKind_FirstForm()
           , CAST ('PrintMovement_ReturnIn32516492' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('32516492', '39135315')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()


-- возвраты поставщ стандарт
      UNION
      SELECT
             zc_movement_returnout()
           , CAST ('ReturnOut' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_ReturnOut' AS TVarChar)

-- Начисления по Юридическому лицу
      UNION
      SELECT
             zc_Movement_ProfitLossService()
           , CAST ('ProfitLossService' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_ProfitLossService' AS TVarChar)

      UNION
-- Транспортная Amstor
      SELECT
             zc_Movement_Sale()
           , CAST ('Transport' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_Transport32516492' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('32516492', '39135315')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()

      UNION
-- Транспортная Метро
      SELECT
             zc_Movement_Sale()
           , CAST ('Transport' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_Transport32049199' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('32049199')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()

      UNION
-- Транспортная Новус
      SELECT
             zc_Movement_Sale()
           , CAST ('Transport' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_Transport36003603' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('36003603')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()

      UNION
      -- Транспортная Фудмережа, Альвар
      SELECT
             zc_Movement_Sale()
           , CAST ('Transport' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_Transport36387249' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('36387249', '36387233', '38916558')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()

      UNION
      -- Справочник Этикетка
      SELECT
             zc_Object_Sticker()
           , CAST ('Sticker' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintObject_Sticker' AS TVarChar)

      UNION
      -- печать качественного Метро
      SELECT
             zc_Movement_Sale()
           , CAST ('Quality' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_Quality32049199' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('32049199')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()

      UNION
      -- печать качественного Фоззі-Фуд ТОВ + СІЛЬПО-ФУД
      SELECT
             zc_Movement_Sale()
           , CAST ('Quality' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_Quality32294926' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('32294926', '40720198', '32294897')
      WHERE Object_Juridical.DescId = zc_Object_Juridical()

      UNION
      -- Печать ТТН
      SELECT
             zc_Movement_TransportGoods()
           , CAST ('TransportGoods' AS TVarChar)
           , CAST ('01.01.2000' AS TDateTime)
           , CAST ('30.09.2021' AS TDateTime)
           , CAST (0 AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_TTN' AS TVarChar)
      UNION
      -- Печать ТТН с 07,10,2021
      SELECT
             zc_Movement_TransportGoods()
           , CAST ('TransportGoods' AS TVarChar)
           , CAST ('01.10.2021' AS TDateTime)
           , CAST ('02.01.2025' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_TTN_071021' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO NOT IN ('41201250', '42599711', '41200660', '42465240', '34465801', '45293717', '42668161', '41360805', '43233918', '33259493', '45041508'
                                          , '44588869' -- Бунар
                                          , '44608319' -- ОЛІВІЯ ТРЕНД
                                          , '45142498' -- на нового клиента Хотей 43233918
                                          , '44915740' -- Нове юр.лице Корвус
                                           )
      WHERE Object_Juridical.DescId = zc_Object_Juridical() 
      UNION
      -- Печать ТТН с 03,01,2025
      SELECT
             zc_Movement_TransportGoods()
           , CAST ('TransportGoods' AS TVarChar)
           , CAST ('03.01.2025' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_TTN_03012025' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO NOT IN ('41201250', '42599711', '41200660', '42465240', '34465801', '45293717', '42668161', '41360805', '43233918', '33259493', '45041508'
                                          , '44588869' -- Бунар
                                          , '44608319' -- ОЛІВІЯ ТРЕНД
                                          , '45142498' -- на нового клиента Хотей 43233918
                                          , '44915740' -- Нове юр.лице Корвус
                                           )
      WHERE Object_Juridical.DescId = zc_Object_Juridical()
      UNION
      -- Печать ТТН для ОКПО
      SELECT
             zc_Movement_TransportGoods()
           , CAST ('TransportGoods' AS TVarChar)
           , CAST ('01.10.2021' AS TDateTime)
           , CAST ('02.01.2025' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_TTN_43233918' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('41201250', '42599711', '41200660', '42465240', '34465801', '45293717', '42668161', '41360805', '43233918', '33259493'
                                      , '44588869' -- Бунар
                                      , '44608319' -- ОЛІВІЯ ТРЕНД
                                      , '45041508'
                                      , '45142498' -- на нового клиента Хотей 43233918
                                      , '44915740' -- Нове юр.лице Корвус
                                       )
      WHERE Object_Juridical.DescId = zc_Object_Juridical()
      UNION
      -- Печать ТТН для ОКПО c 03.01.2025
      SELECT
             zc_Movement_TransportGoods()
           , CAST ('TransportGoods' AS TVarChar)
           , CAST ('03.01.2025' AS TDateTime)
           , CAST ('01.01.2200' AS TDateTime)
           , CAST (Object_Juridical.Id AS INTEGER)
           , CAST (0 AS INTEGER)
           , CAST ('PrintMovement_TTN_43233918_03012025' AS TVarChar)
      FROM Object AS Object_Juridical
      JOIN ObjectHistory_JuridicalDetails_View AS OH_JuridicalDetails ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
       AND OH_JuridicalDetails.OKPO IN ('41201250', '42599711', '41200660', '42465240', '34465801', '45293717', '42668161', '41360805', '43233918', '33259493'
                                      , '44588869' -- Бунар
                                      , '44608319' -- ОЛІВІЯ ТРЕНД
                                      , '45041508'
                                      , '45142498' -- на нового клиента Хотей 43233918
                                      , '44915740' -- Нове юр.лице Корвус
                                       )
      WHERE Object_Juridical.DescId = zc_Object_Juridical()

--   ORDER BY 1,2,4


       ;

ALTER TABLE PrintForms_View OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 05.10.21         *
 24.02.21         * add Tax0321, TaxCorrective0321
 17.12.18         * PrintMovement_Quality32049199
 26.10.17         * add PrintObject_Sticker
 19.06.17         * add PrintMovement_Sale2902403938
 15.03.17         * add Tax0317, TaxCorrective0317
 01.02.16         * add PrintMovement_Transport
 21.12.15         * add PrintMovement_Sale36003603 Новус
                      , PrintMovement_Sale39118745
 18.12.15         * add PrintMovement_Sale2DiscountPrice
 28.01.15                                                        * + PrintMovement_ReturnIn32049199
 25.11.14                                                        * + new nalog forms
 23.04.14                                                        * + PrintMovement_ReturnIn32049199
 07.04.14                                                        * + Bill
 03.04.14                                                        * + Bill
 02.04.14                                                        * + Adventis + Billa + Kray
 27.02.14                                                        * + Tax
 26.02.14                                                        * + FM, Metro
 25.02.14                                                        * + OKPO
 24.02.14                                                        * + fix milti OKPO
 18.02.14                                                        * + OKPO
 17.02.14                                                        * + ProfitLossService
 10.02.14                                                        * + TaxCorrective, ReturnOut
 06.02.14                                                        * + ReturnIn
 05.02.14                                                        *
*/

/*
----------------
PrintMovement_Sale01074874.fr3 -- ВСП Локомотивне депо Джанкой ТЧ-10
PrintMovement_Sale2902403938.fr3 -- Сидоров Євген Васильович ФОП
PrintMovement_Sale30487219.fr3 -- АТБ-МАРКЕТ  ТОВ
PrintMovement_Sale32516492.fr3 -- Амстор Торгiвельний будинок ТОВ
PrintMovement_Sale35275230.fr3 -- Адвентіс ТОВ
PrintMovement_Sale37910513.fr3 -- Фуршет Центр ДП
*/

-- тест
-- SELECT * FROM PrintForms_View LEFT JOIN Object ON Object.Id = JuridicalId WHERE JuridicalId IN (SELECT JuridicalId FROM PrintForms_View GROUP BY JuridicalId, ReportType, PaidKindId, StartDate HAVING COUNT(*) > 1) ORDER BY ReportType, JuridicalId, PaidKindId, StartDate
-- SELECT * FROM PrintForms_View LEFT JOIN Object ON Object.Id = JuridicalId WHERE PrintFormName = 'PrintMovement_Sale35275230'
