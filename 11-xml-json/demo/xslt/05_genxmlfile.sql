Select TOP 10 StockItemID, StockItemName, UnitPrice
from Warehouse.StockItems
FOR XML RAW('item'), ROOT('items'), ELEMENTS