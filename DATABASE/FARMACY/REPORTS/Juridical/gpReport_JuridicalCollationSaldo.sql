-- Function: gpReport_JuridicalCollationSaldo()

DROP FUNCTION IF EXISTS gpReport_JuridicalCollationSaldo (TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_JuridicalCollationSaldo(
    IN inStartDate          TDateTime  ,
    IN inJuridical_BasisId  Integer  ,
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Sale());
    vbUserId:= inSession;

    OPEN Cursor1 FOR
      WITH tmpContainer AS (SELECT CLO_JuridicalBasis.ContainerId
                                 , Container.Amount
                            FROM ContainerLinkObject AS CLO_JuridicalBasis

                                 INNER JOIN Container ON Container.Id = CLO_JuridicalBasis.ContainerId
                                                     AND Container.DescId = zc_Container_Summ()

                            WHERE CLO_JuridicalBasis.ObjectId = inJuridical_BasisId
                              AND CLO_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis())

         , tmpContainerSumm AS (SELECT tmpContainer.ContainerId
                                     , tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS Amount
                                   FROM tmpContainer
                                        LEFT JOIN MovementItemContainer AS MIContainer
                                                                        ON MIContainer.Containerid = tmpContainer.ContainerId
                                                                       AND MIContainer.OperDate >= date_trunc('day', inStartDate)
                                   GROUP BY tmpContainer.ContainerId, tmpContainer.Amount)





      SELECT CLO_Juridical.ObjectId                                               AS Code,
             Object_Juridical.ValueData                                           AS Name,
             CASE WHEN Sum(Container.Amount) > 0 THEN Sum(Container.Amount) END   AS Debet,
             CASE WHEN Sum(Container.Amount) < 0 THEN - Sum(Container.Amount) END AS Kredit
      FROM tmpContainerSumm AS Container

           INNER JOIN ContainerLinkObject AS CLO_Juridical
                                         ON CLO_Juridical.ContainerId = Container.ContainerId
                                        AND CLO_Juridical.DescId = zc_ContainerLinkObject_Juridical()

           LEFT JOIN Object as Object_Juridical ON Object_Juridical.ID = CLO_Juridical.ObjectId


      GROUP BY CLO_Juridical.ObjectId, Object_Juridical.ValueData
      HAVING Sum(Container.Amount) <> 0
      ORDER BY Object_Juridical.ValueData;
    RETURN NEXT Cursor1;


    OPEN Cursor2 FOR
      WITH tmpContainer AS (SELECT Container.ID AS ContainerId
                                 , Container.ObjectId
                                 , Container.Amount
                            FROM Container

                                 INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                                       ON ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                                                      AND ObjectLink_Unit_Juridical.ObjectId = Container.WhereObjectId

                            WHERE ObjectLink_Unit_Juridical.ChildObjectId = inJuridical_BasisId
                              AND Container.DescId = zc_Container_Count())

         , tmpContainerSumm AS (SELECT tmpContainer.ContainerId
                                     , tmpContainer.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS Amount
                                   FROM tmpContainer
                                        LEFT JOIN MovementItemContainer AS MIContainer
                                                                        ON MIContainer.Containerid = tmpContainer.ContainerId
                                                                       AND MIContainer.OperDate >= date_trunc('day', inStartDate)
                                   GROUP BY tmpContainer.ContainerId, tmpContainer.Amount)





      SELECT
              Object_NDSKind.ValueData                                                            AS NDSKindName
            , Sum(Round(COALESCE (MIFloat_PriceWithOutVAT.ValueData, 0) * Container.Amount, 2))   AS SummaWith
            , Sum(Round(COALESCE (MIFloat_JuridicalPrice.ValueData, 0) * Container.Amount, 2) -
              Round(COALESCE (MIFloat_PriceWithOutVAT.ValueData, 0) * Container.Amount, 2))       AS SummaNDS
            , Sum(Round(COALESCE (MIFloat_JuridicalPrice.ValueData, 0) * Container.Amount, 2))    AS Summa


      FROM tmpContainerSumm AS Container

        -- партия
       LEFT OUTER JOIN ContainerLinkObject AS CLI_MI
                                           ON CLI_MI.ContainerId = Container.ContainerId
                                          AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
       LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
        -- элемент прихода
       LEFT OUTER JOIN MovementItem AS MI_Income
                                    ON MI_Income.Id = Object_PartionMovementItem.ObjectCode

        -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
       LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                   ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                  AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
         -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
       LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)

         -- цена с учетом НДС, для элемента прихода от поставщика (или NULL)
       LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPrice
                                   ON MIFloat_JuridicalPrice.MovementItemId = COALESCE (MI_Income_find.Id, MI_Income.Id)
                                  AND MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()

         -- цена без учета НДС, для элемента прихода от поставщика (или NULL)
       LEFT JOIN MovementItemFloat AS MIFloat_PriceWithOutVAT
                                   ON MIFloat_PriceWithOutVAT.MovementItemId = COALESCE (MI_Income_find.Id, MI_Income.Id)
                                  AND MIFloat_PriceWithOutVAT.DescId = zc_MIFloat_PriceWithOutVAT()


         -- НДС, для элемента прихода от поставщика (или NULL)
       LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                    ON MovementLinkObject_NDSKind.MovementId = COALESCE (MI_Income_find.MovementId, MI_Income.MovementId)
                                   AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()

       LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = MovementLinkObject_NDSKind.ObjectId

       GROUP BY Object_NDSKind.ValueData ;
    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_JuridicalCollationSaldo (TDateTime, Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 23.01.19        *
*/

-- SELECT * FROM gpReport_JuridicalCollationSaldo ('01.01.2019'::TDateTime, 7433753, '3');