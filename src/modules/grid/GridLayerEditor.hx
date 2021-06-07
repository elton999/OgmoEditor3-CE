package modules.grid;

import level.editor.Editor;
import level.editor.LayerEditor;

class GridLayerEditor extends LayerEditor
{
	public var brushLeft: String;
	public var brushRight: String;

	public function new(id:Int)
	{
		super(id);

		//Default brushes
		brushLeft = (cast template : GridLayerTemplate).firstSolid;
		brushRight = (cast template : GridLayerTemplate).transparent;
	}

	override function draw(offset_x : Float = 0, offset_y : Float = 0):Void
	{
		for (y in 0...(cast layer : GridLayer).data[0].length)
		{
			var last:String = null;
			var range:Int = 0;

			for (x in 0...(cast layer : GridLayer).data.length + 1)
			{
			var at:String = null;
			if (x < (cast layer : GridLayer).data.length) at = (cast layer : GridLayer).data[x][y];

			if (at != last)
			{
				if (range > 0 && last != null)
				{
				var startX = x - range;
				var c = (cast template : GridLayerTemplate).legend[last];
				if (c != null && !c.equals(Color.transparent))
					EDITOR.draw.drawRect(
						offset_x + layer.offset.x + startX * template.gridSize.x,
						offset_y + layer.offset.y + y * template.gridSize.y,
						template.gridSize.x * range,
						template.gridSize.y,
						c);
				}
				range = 0;
				last = at;
			}
			range++;
			}
		}

		// left bar
		EDITOR.draw.drawRect(
			offset_x+layer.offset.x,
			offset_y+layer.offset.y,
			2,
			(cast layer : GridLayer).data[0].length * template.gridSize.y,
			Color.white);
		
		// right bar
		EDITOR.draw.drawRect(
			offset_x+layer.offset.x + ((cast layer : GridLayer).data.length * template.gridSize.x),
			offset_y+layer.offset.y,
			2,
			(cast layer : GridLayer).data[0].length * template.gridSize.y,
			Color.white);

		// top bar
		EDITOR.draw.drawRect(
			offset_x+layer.offset.x,
			offset_y+layer.offset.y,
			(cast layer : GridLayer).data.length * template.gridSize.x,
			2,
			Color.white);
		
		// bottom bar
		EDITOR.draw.drawRect(
			offset_x+layer.offset.x,
			offset_y+layer.offset.y + ((cast layer : GridLayer).data[0].length * template.gridSize.y),
			(cast layer : GridLayer).data.length * template.gridSize.x,
			2,
			Color.white);
	}

	override function createPalettePanel()
	{
		return new GridPalettePanel(this);
	}

	override public function afterUndoRedo()
	{
		EDITOR.toolBelt.current.activated();
	}
}
