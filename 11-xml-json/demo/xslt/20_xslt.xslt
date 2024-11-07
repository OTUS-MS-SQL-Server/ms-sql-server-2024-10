<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
    <html>
    <body>
		<h2>StockItems:-</h2>
		<table border = "1">
			<tr bgcolor = "#cd8932">
				<th>StockItem ID</th>
				<th>StockItem Name</th>
				<th>Price</th>
			</tr>
			<xsl:for-each select="items/item">
				<tr bgcolor = "#84cd32">
					<td>
						<xsl:value-of select = "StockItemID"/>
					</td>
					<td>
						<xsl:value-of select = "StockItemName"/>
					</td>
					<td>
						<xsl:value-of select = "UnitPrice"/>
					</td>
				</tr>
			</xsl:for-each>
		</table>
	</body>
    </html>
</xsl:template>

</xsl:stylesheet>