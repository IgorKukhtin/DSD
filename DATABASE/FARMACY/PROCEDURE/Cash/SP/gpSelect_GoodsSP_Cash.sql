 -- Function: gpSelect_GoodsSP_Cash()

--DROP FUNCTION IF EXISTS gpSelect_GoodsSP_Cash (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_GoodsSP_Cash (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsSP_Cash(
    IN inMedicalProgramSPId  Integer ,
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id            Integer
             , GoodsId       Integer
             , GoodsCode     Integer
             , GoodsName     TVarChar
             , Price         TFloat
             , PricePay      TFloat
             , Amount        TFloat
             , AmountRetail  TFloat
             , ColSP         TFloat
             , CountSP       TFloat
             , PriceOptSP    TFloat
             , PriceRetSP    TFloat
             , DailyNormSP   TFloat
             , DailyCompensationSP  TFloat
             , PriceSP       TFloat
             , PaymentSP     TFloat
             , GroupSP       TFloat
             , DenumeratorValueSP TFloat
             , Pack          TVarChar
             , CodeATX       TVarChar
             , MakerSP       TVarChar
             , ReestrSP      TVarChar
             , ReestrDateSP  TVarChar
             , IdSP          TVarChar
             , DosageIdSP    TVarChar
             , ProgramIdSP       TVarChar
             , NumeratorUnitSP   TVarChar
             , DenumeratorUnitSP TVarChar
             , DynamicsSP        TVarChar
             , IntenalSPId   Integer
             , IntenalSPName TVarChar
             , BrandSPId     Integer
             , BrandSPName   TVarChar
             , KindOutSPId   Integer
             , KindOutSPName TVarChar
             , isErased      Boolean
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbRetailId Integer;
   DECLARE vbLanguage TVarChar;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_GoodsSP());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;

    vbRetailId := (SELECT ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                   FROM ObjectLink AS ObjectLink_Unit_Juridical
                        INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                              ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                   WHERE ObjectLink_Unit_Juridical.ObjectId = vbUnitId
                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical());

    SELECT COALESCE (ObjectString_Language.ValueData, 'RU')::TVarChar                AS Language
    INTO vbLanguage
    FROM Object AS Object_User
                 
         LEFT JOIN ObjectString AS ObjectString_Language
                ON ObjectString_Language.ObjectId = Object_User.Id
               AND ObjectString_Language.DescId = zc_ObjectString_User_Language()
              
    WHERE Object_User.Id = vbUserId;    
    
    RETURN QUERY
    WITH -- Товары соц-проект
           tmpMedicalProgramSPUnit AS (SELECT ObjectLink_MedicalProgramSP.ChildObjectId         AS MedicalProgramSPId
                                            , ObjectLink_Unit.ChildObjectId                     AS UnitId
                                       FROM Object AS Object_MedicalProgramSPLink
                                            INNER JOIN ObjectLink AS ObjectLink_MedicalProgramSP
                                                                  ON ObjectLink_MedicalProgramSP.ObjectId = Object_MedicalProgramSPLink.Id
                                                                 AND ObjectLink_MedicalProgramSP.DescId = zc_ObjectLink_MedicalProgramSPLink_MedicalProgramSP()
                                            INNER JOIN ObjectLink AS ObjectLink_Unit
                                                                  ON ObjectLink_Unit.ObjectId = Object_MedicalProgramSPLink.Id
                                                                 AND ObjectLink_Unit.DescId = zc_ObjectLink_MedicalProgramSPLink_Unit()
                                        WHERE Object_MedicalProgramSPLink.DescId = zc_Object_MedicalProgramSPLink()
                                          AND Object_MedicalProgramSPLink.isErased = False),
           tmpMovement AS (SELECT Movement.Id
                                , Movement.OperDate
                                , MLO_MedicalProgramSP.ObjectId    AS MedicalProgramSPID
                           FROM Movement

                                INNER JOIN MovementDate AS MovementDate_OperDateStart
                                                        ON MovementDate_OperDateStart.MovementId = Movement.Id
                                                       AND MovementDate_OperDateStart.DescId     = zc_MovementDate_OperDateStart()
                                                       AND MovementDate_OperDateStart.ValueData  <= CURRENT_DATE

                                INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                                        ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                                       AND MovementDate_OperDateEnd.DescId     = zc_MovementDate_OperDateEnd()
                                                       AND MovementDate_OperDateEnd.ValueData  >= CURRENT_DATE

                               INNER JOIN MovementLinkObject AS MLO_MedicalProgramSP
                                                             ON MLO_MedicalProgramSP.MovementId = Movement.Id
                                                            AND MLO_MedicalProgramSP.DescId = zc_MovementLink_MedicalProgramSP()

                           WHERE Movement.DescId = zc_Movement_GoodsSP()
                             AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                             AND (COALESCE (MLO_MedicalProgramSP.ObjectId, 0) = inMedicalProgramSPId OR COALESCE(inMedicalProgramSPId, 0) = 0)
                          ),
           tmpMovementItem AS (SELECT MovementItem.Id
                                    , Movement.MedicalProgramSPID
                                    , Object_Goods_Retail.Id       AS GoodsId
                                    , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId ORDER BY Movement.OperDate DESC) AS Ord
                               FROM tmpMovement AS Movement

                                   INNER JOIN MovementItem ON MovementItem.DescId = zc_MI_Master()
                                                          AND MovementItem.MovementId = Movement.ID
                                                          AND MovementItem.isErased = FALSE
                                                          
                                   LEFT JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.GoodsMainId = MovementItem.ObjectId
                                                                                       AND Object_Goods_Retail.RetailId = vbRetailId
                               ),
           tmpMovementItemGroup AS (SELECT DISTINCT tmpMovementItem.GoodsId
                                         , tmpMedicalProgramSPUnit.UnitId
                                    FROM tmpMovementItem
                                         INNER JOIN tmpMedicalProgramSPUnit ON tmpMedicalProgramSPUnit.MedicalProgramSPID = tmpMovementItem.MedicalProgramSPID
                                   ),
           tmpObject_Price AS (SELECT CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                     AND ObjectFloat_Goods_Price.ValueData > 0
                                    THEN ROUND (ObjectFloat_Goods_Price.ValueData, 2)
                                    ELSE ROUND (Price_Value.ValueData, 2)
                               END :: TFloat                           AS Price
                             , MCS_Value.ValueData                     AS MCSValue
                             , Price_Goods.ChildObjectId               AS GoodsId
                        FROM ObjectLink AS ObjectLink_Price_Unit
                           LEFT JOIN ObjectLink AS Price_Goods
                                                ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                               AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                           LEFT JOIN ObjectFloat AS Price_Value
                                                 ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                           LEFT JOIN ObjectFloat AS MCS_Value
                                                 ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                           -- Фикс цена для всей Сети
                           LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                                  ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                                                 AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                           LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                   ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                                  AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                        WHERE ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                          AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                        ),
           tmpContainerAll AS (SELECT  Container.ObjectId                                   AS GoodsId
                                     , Container.WhereObjectId                              AS UnitId
                                     , SUM(Container.Amount)                                AS Amount
                                FROM Container

                                WHERE Container.DescId = zc_Container_Count()
                                  AND Container.Amount <> 0
                                  AND Container.ObjectId IN (SELECT tmpMovementItem.GoodsId FROM tmpMovementItem)
                                GROUP BY Container.ObjectId
                                       , Container.WhereObjectId
                               ),
           tmpContainerSP AS (SELECT Container.GoodsId                                   AS GoodsId
                                   , Container.UnitId                                    AS UnitId
                                   , Container.Amount                                    AS Amount
                                FROM tmpContainerAll AS Container
                                     INNER JOIN tmpMovementItemGroup ON tmpMovementItemGroup.GoodsId = Container.GoodsId
                                                                    AND tmpMovementItemGroup.UnitId = Container.UnitId
                               ),
           tmpContainerRateil AS (SELECT Container.GoodsId
                                       , SUM(Container.Amount)                              AS Amount
                                  FROM tmpContainerSP AS Container
                                  GROUP BY Container.GoodsId
                                  )

        SELECT MovementItem.Id                                       AS Id
             , MovementItem.GoodsId                                  AS GoodsId
             , Object_Goods.ObjectCode                    ::Integer  AS GoodsCode
             , CASE WHEN vbLanguage = 'UA' AND COALESCE(Object_Goods.NameUkr, '') <> ''
                    THEN Object_Goods.NameUkr
                    ELSE Object_Goods.Name END                       AS GoodsName

             , COALESCE(tmpObject_Price.Price,0)::TFloat             AS Price
             , CASE WHEN COALESCE(tmpObject_Price.Price - MIFloat_PriceSP.ValueData, 0) > 0
               THEN COALESCE(tmpObject_Price.Price - MIFloat_PriceSP.ValueData,0)
               ELSE 0 END::TFloat                                    AS PricePay
             , tmpContainerUnit.Amount::TFloat                       AS Amount
             , tmpContainerRateil.Amount::TFloat                     AS AmountRetail

             , MIFloat_ColSP.ValueData                               AS ColSP
             , MIFloat_CountSP.ValueData                             AS CountSP
             , MIFloat_PriceOptSP.ValueData                          AS PriceOptSP
             , MIFloat_PriceRetSP.ValueData                          AS PriceRetSP
             , MIFloat_DailyNormSP.ValueData                         AS DailyNormSP
             , MIFloat_DailyCompensationSP.ValueData                 AS DailyCompensationSP
             , MIFloat_PriceSP.ValueData                             AS PriceSP
             , MIFloat_PaymentSP.ValueData                           AS PaymentSP
             , MIFloat_GroupSP.ValueData                             AS GroupSP
             , MIFloat_DenumeratorValueSP.ValueData                  AS DenumeratorValueSP

             , MIString_Pack.ValueData                               AS Pack
             , MIString_CodeATX.ValueData                            AS CodeATX
             , MIString_MakerSP.ValueData                            AS MakerSP
             , MIString_ReestrSP.ValueData                           AS ReestrSP
             , MIString_ReestrDateSP.ValueData                       AS ReestrDateSP
             , COALESCE (MIString_IdSP.ValueData, '')     ::TVarChar AS IdSP
             , COALESCE (MIString_DosageIdSP.ValueData,'')::TVarChar AS DosageIdSP

             , COALESCE (MIString_ProgramIdSP.ValueData, '')      ::TVarChar AS ProgramIdSP
             , COALESCE (MIString_NumeratorUnitSP.ValueData, '')  ::TVarChar AS NumeratorUnitSP
             , COALESCE (MIString_DenumeratorUnitSP.ValueData, '')::TVarChar AS DenumeratorUnitSP
             , COALESCE (MIString_DynamicsSP.ValueData, '')       ::TVarChar AS DynamicsSP

             , COALESCE(Object_IntenalSP.Id ,0)           ::Integer  AS IntenalSPId
             , COALESCE(Object_IntenalSP.ValueData,'')    ::TVarChar AS IntenalSPName
             , COALESCE(Object_BrandSP.Id ,0)             ::Integer  AS BrandSPId
             , COALESCE(Object_BrandSP.ValueData,'')      ::TVarChar AS BrandSPName

             , COALESCE(Object_KindOutSP.Id ,0)           ::Integer  AS KindOutSPId
             , COALESCE(Object_KindOutSP.ValueData,'')    ::TVarChar AS KindOutSPName

             , FALSE    ::Boolean                                    AS isErased

        FROM tmpMovementItem AS MovementItem

            LEFT JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = MovementItem.GoodsId
            LEFT JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = Object_Goods_Retail.GoodsMainId

            LEFT JOIN MovementItemFloat AS MIFloat_ColSP
                                        ON MIFloat_ColSP.MovementItemId = MovementItem.Id
                                       AND MIFloat_ColSP.DescId = zc_MIFloat_ColSP()
            LEFT JOIN MovementItemFloat AS MIFloat_CountSP
                                        ON MIFloat_CountSP.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountSP.DescId = zc_MIFloat_CountSP()
            LEFT JOIN MovementItemFloat AS MIFloat_PriceOptSP
                                        ON MIFloat_PriceOptSP.MovementItemId = MovementItem.Id
                                       AND MIFloat_PriceOptSP.DescId = zc_MIFloat_PriceOptSP()
            LEFT JOIN MovementItemFloat AS MIFloat_PriceRetSP
                                        ON MIFloat_PriceRetSP.MovementItemId = MovementItem.Id
                                       AND MIFloat_PriceRetSP.DescId = zc_MIFloat_PriceRetSP()
            LEFT JOIN MovementItemFloat AS MIFloat_DailyNormSP
                                        ON MIFloat_DailyNormSP.MovementItemId = MovementItem.Id
                                       AND MIFloat_DailyNormSP.DescId = zc_MIFloat_DailyNormSP()
            LEFT JOIN MovementItemFloat AS MIFloat_DailyCompensationSP
                                        ON MIFloat_DailyCompensationSP.MovementItemId = MovementItem.Id
                                       AND MIFloat_DailyCompensationSP.DescId = zc_MIFloat_DailyCompensationSP()
            LEFT JOIN MovementItemFloat AS MIFloat_PriceSP
                                        ON MIFloat_PriceSP.MovementItemId = MovementItem.Id
                                       AND MIFloat_PriceSP.DescId = zc_MIFloat_PriceSP()
            LEFT JOIN MovementItemFloat AS MIFloat_PaymentSP
                                        ON MIFloat_PaymentSP.MovementItemId = MovementItem.Id
                                       AND MIFloat_PaymentSP.DescId = zc_MIFloat_PaymentSP()
            LEFT JOIN MovementItemFloat AS MIFloat_GroupSP
                                        ON MIFloat_GroupSP.MovementItemId = MovementItem.Id
                                       AND MIFloat_GroupSP.DescId = zc_MIFloat_GroupSP()
             LEFT JOIN MovementItemFloat AS MIFloat_DenumeratorValueSP
                                         ON MIFloat_DenumeratorValueSP.MovementItemId = MovementItem.Id
                                        AND MIFloat_DenumeratorValueSP.DescId = zc_MIFloat_DenumeratorValueSP()

            LEFT JOIN MovementItemString AS MIString_Pack
                                         ON MIString_Pack.MovementItemId = MovementItem.Id
                                        AND MIString_Pack.DescId = zc_MIString_Pack()
            LEFT JOIN MovementItemString AS MIString_CodeATX
                                         ON MIString_CodeATX.MovementItemId = MovementItem.Id
                                        AND MIString_CodeATX.DescId = zc_MIString_CodeATX()
            LEFT JOIN MovementItemString AS MIString_MakerSP
                                         ON MIString_MakerSP.MovementItemId = MovementItem.Id
                                        AND MIString_MakerSP.DescId = zc_MIString_MakerSP()
            LEFT JOIN MovementItemString AS MIString_ReestrSP
                                         ON MIString_ReestrSP.MovementItemId = MovementItem.Id
                                        AND MIString_ReestrSP.DescId = zc_MIString_ReestrSP()
            LEFT JOIN MovementItemString AS MIString_ReestrDateSP
                                         ON MIString_ReestrDateSP.MovementItemId = MovementItem.Id
                                        AND MIString_ReestrDateSP.DescId = zc_MIString_ReestrDateSP()
            LEFT JOIN MovementItemString AS MIString_IdSP
                                         ON MIString_IdSP.MovementItemId = MovementItem.Id
                                        AND MIString_IdSP.DescId = zc_MIString_IdSP()
            LEFT JOIN MovementItemString AS MIString_DosageIdSP
                                         ON MIString_DosageIdSP.MovementItemId = MovementItem.Id
                                        AND MIString_DosageIdSP.DescId = zc_MIString_DosageIdSP()

             LEFT JOIN MovementItemString AS MIString_DynamicsSP
                                          ON MIString_DynamicsSP.MovementItemId = MovementItem.Id
                                         AND MIString_DynamicsSP.DescId = zc_MIString_DynamicsSP()
             LEFT JOIN MovementItemString AS MIString_DenumeratorUnitSP
                                          ON MIString_DenumeratorUnitSP.MovementItemId = MovementItem.Id
                                         AND MIString_DenumeratorUnitSP.DescId = zc_MIString_DenumeratorUnitSP()
             LEFT JOIN MovementItemString AS MIString_ProgramIdSP
                                          ON MIString_ProgramIdSP.MovementItemId = MovementItem.Id
                                         AND MIString_ProgramIdSP.DescId = zc_MIString_ProgramIdSP()
             LEFT JOIN MovementItemString AS MIString_NumeratorUnitSP
                                          ON MIString_NumeratorUnitSP.MovementItemId = MovementItem.Id
                                         AND MIString_NumeratorUnitSP.DescId = zc_MIString_NumeratorUnitSP()

            LEFT JOIN MovementItemLinkObject AS MI_IntenalSP
                                             ON MI_IntenalSP.MovementItemId = MovementItem.Id
                                            AND MI_IntenalSP.DescId = zc_MILinkObject_IntenalSP()
            LEFT JOIN Object AS Object_IntenalSP ON Object_IntenalSP.Id = MI_IntenalSP.ObjectId

            LEFT JOIN MovementItemLinkObject AS MI_BrandSP
                                             ON MI_BrandSP.MovementItemId = MovementItem.Id
                                            AND MI_BrandSP.DescId = zc_MILinkObject_BrandSP()
            LEFT JOIN Object AS Object_BrandSP ON Object_BrandSP.Id = MI_BrandSP.ObjectId

            LEFT JOIN MovementItemLinkObject AS MI_KindOutSP
                                             ON MI_KindOutSP.MovementItemId = MovementItem.Id
                                            AND MI_KindOutSP.DescId = zc_MILinkObject_KindOutSP()
            LEFT JOIN Object AS Object_KindOutSP ON Object_KindOutSP.Id = MI_KindOutSP.ObjectId

            LEFT JOIN tmpObject_Price ON tmpObject_Price.GoodsId = MovementItem.GoodsId

            LEFT JOIN tmpContainerSP AS tmpContainerUnit 
                                     ON tmpContainerUnit.GoodsId = MovementItem.GoodsId
                                    AND tmpContainerUnit.UnitId = vbUnitId
                                     
            LEFT JOIN tmpContainerRateil ON tmpContainerRateil.GoodsId = MovementItem.GoodsId

         WHERE MovementItem.Ord = 1
         ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 21.10.20                                                      *
*/

--ТЕСТ
--

SELECT * FROM gpSelect_GoodsSP_Cash (inMedicalProgramSPId := 18078228  , inSession:= '3')