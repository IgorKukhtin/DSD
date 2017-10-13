    -- !!!ТЕСТ!!!
    SELECT Object_Goods.ObjectCode
         , Object_Unit.Id     as UnitId
         , Object_Unit.ValueData
        --  , ObjectLink_Price_Unit.ObjectId          AS Id
    FROM ObjectLink        AS ObjectLink_Price_Unit
         INNER JOIN ObjectLink       AS Price_Goods
                 ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
         INNER JOIN Object  AS Object_Goods ON Object_Goods.Id = Price_Goods.ChildObjectId
         INNER JOIN Object  AS Object_Unit ON Object_Unit.Id = ObjectLink_Price_Unit.ChildObjectId

    WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
      -- AND Object_Unit.Id = 5778622 
    GROUP BY Object_Goods.ObjectCode
           , Object_Unit.Id
           , Object_Unit.ValueData
    HAVING count(*) > 1
    order by 3, 1



    -- !!!УДАЛЕНИЕ!!!
    with tmp1 as  (SELECT Object_Goods.ObjectCode
                        , Object_Unit.Id     as UnitId
                        , Object_Unit.ValueData
                       --  , ObjectLink_Price_Unit.ObjectId          AS Id
                   FROM ObjectLink        AS ObjectLink_Price_Unit
                        INNER JOIN ObjectLink       AS Price_Goods
                                ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                               AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                        INNER JOIN Object  AS Object_Goods ON Object_Goods.Id = Price_Goods.ChildObjectId
                        INNER JOIN Object  AS Object_Unit ON Object_Unit.Id = ObjectLink_Price_Unit.ChildObjectId
               
                   WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                     -- AND Object_Unit.Id = 5778622 
                   GROUP BY Object_Goods.ObjectCode
                          , Object_Unit.Id
                          , Object_Unit.ValueData
                   HAVING count(*) > 1
                  )
    SELECT Object_Goods.ObjectCode
         , Object_Unit.Id     as UnitId
         , Object_Unit.ValueData
         , Object.*
         , Object_Object.ValueData
         , Object_Retail.ValueData as YnitRetailName

         -- , lpInsertUpdate_ObjectLink(zc_ObjectLink_Price_Goods(), Object.Id, NULL)
         -- , lpInsertUpdate_ObjectLink(zc_ObjectLink_Price_Unit(), Object.Id, NULL)

    FROM ObjectLink        AS ObjectLink_Price_Unit
         INNER JOIN Object  ON Object  .Id = ObjectLink_Price_Unit.ObjectId

         INNER JOIN ObjectLink       AS Price_Goods
                 ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
         INNER JOIN Object  AS Object_Goods ON Object_Goods.Id = Price_Goods.ChildObjectId
         INNER JOIN Object  AS Object_Unit ON Object_Unit.Id = ObjectLink_Price_Unit.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                             ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
           LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                               AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
           LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

         -- связь с Юридические лица или Торговая сеть или ...
         LEFT JOIN ObjectLink AS ObjectLink_Goods_Object
                              ON ObjectLink_Goods_Object.ObjectId = Object_Goods.Id
                             AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
         LEFT JOIN Object  AS Object_Object ON Object_Object.Id = ObjectLink_Goods_Object.ChildObjectId

         inner join tmp1 on  tmp1 .ObjectCode  = Object_Goods.ObjectCode
                          and tmp1 .UnitId   = Object_Unit.Id 

    WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
--      AND Object_Unit.Id          = 4103485
--      AND Object_Goods.ObjectCode = 2287
        and Object_Retail.Id <> Object_Object.Id
   order by 3, 1





    -- !!!УДАЛЕНИЕ!!!
    SELECT DISTINCT
           Object_Goods.*
         , Object_Unit.*
         , Object_Object.*
         , Object_Retail.*
         , Movement.*
    FROM Container 
         inner join Object  AS Object_Goods on Object_Goods .Id = Container .ObjectId
         -- связь с Юридические лица или Торговая сеть или ...
         LEFT JOIN ObjectLink AS ObjectLink_Goods_Object
                              ON ObjectLink_Goods_Object.ObjectId = Object_Goods.Id
                             AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
         LEFT JOIN Object  AS Object_Object ON Object_Object.Id = ObjectLink_Goods_Object.ChildObjectId

           LEFT JOIN Object  AS Object_Unit ON Object_Unit.Id = Container .WhereObjectId
           LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                               AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
           LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                               AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
           LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

           -- LEFT JOIN MovementItemContainer on MovementItemContainer.ContainerId = Container.Id
           INNER JOIN MovementItemContainer on MovementItemContainer.ContainerId = Container.Id
           left JOIN Movement on Movement.Id = MovementItemContainer.MovementId

    WHERE Container .DescId = 1
      and Container .Amount <> 0
      and Object_Retail.Id <> Object_Object.Id
      -- and Object_Goods.Id in (8818, 3034137)
      -- and Object_Goods.ObjectCode in (8818, 3034137)
      -- and MovementItemContainer.ContainerId is null
    order by 3

