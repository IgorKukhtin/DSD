-- View: Object_Unit_View

DROP VIEW IF EXISTS LastPriceList_View;

CREATE OR REPLACE VIEW LastPriceList_View AS 

  SELECT JuridicalId, ContractId, MovementId, AreaId
  FROM (SELECT MAX (Movement.OperDate) OVER (PARTITION BY MovementLinkObject_Juridical.ObjectId
                                                        , COALESCE (MovementLinkObject_Contract.ObjectId, 0)
                                                        , COALESCE (MovementLinkObject_Area.ObjectId, 0)
                                            ) AS Max_Date
              , Movement.OperDate
              , Movement.Id AS MovementId
              , MovementLinkObject_Juridical.ObjectId              AS JuridicalId 
              , COALESCE (MovementLinkObject_Contract.ObjectId, 0) AS ContractId
              , COALESCE (MovementLinkObject_Area.ObjectId, 0)     AS AreaId
        FROM Movement
             LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                          ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                         AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
             LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                          ON MovementLinkObject_Contract.MovementId = Movement.Id
                                         AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
             LEFT JOIN MovementLinkObject AS MovementLinkObject_Area
                                          ON MovementLinkObject_Area.MovementId = Movement.Id
                                         AND MovementLinkObject_Area.DescId = zc_MovementLinkObject_Area()                                       
        WHERE Movement.DescId = zc_Movement_PriceList()
          AND Movement.StatusId <> zc_Enum_Status_Erased()
        ) AS PriceList
  WHERE PriceList.Max_Date = PriceList.OperDate;

ALTER TABLE LastPriceList_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.10.17         * add AreaId
 12.09.14                        * 
*/

-- ����
-- SELECT * FROM LastPriceList_View
