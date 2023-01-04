function [] = animateSolution( resultObject, saveGIF)

    nDimensions = size( resultObject.start, 2);

    if( nDimensions ~= 2 )
        error("Animation is only supported in 2D.");
    end

    map = resultObject.map;
    [ n, m] = size( map );

    startX = resultObject.start(2);
    startY = resultObject.start(1);

    targetX = resultObject.target(2);
    targetY = resultObject.target(1);

    paths = resultObject.paths;
    nSteps = length( paths );

    hFig = figure();
    hFig.Units = "normalized";
    hFig.OuterPosition = [0 0 1 1];

    cm = flipud( gray );
    colormap( cm );

    if( saveGIF )

        timestamp = datetime( "now", "Format", 'yyyy-MM-dd-HH_mm_ss');
        timestamp = string( timestamp );

        fileName = "gifs/solution_";
        fileName = fileName + timestamp;
        fileName = fileName + ".gif";
    end

    for kk = 1:nSteps
        
        step_kk = paths{kk};
        step_kk_ii = step_kk( :, 1);
        step_kk_jj = step_kk( :, 2);
        inds_kk = sub2ind( [ n, m], step_kk_ii, step_kk_jj);
    
        map( inds_kk ) = 0.5;
    
        hold off
        imagesc( map );
    
        hold on
        h = plot( startX, startY, '.');
        h.MarkerSize = 25;
        h.Color = "red";
    
        h = plot( targetX, targetY, '.');
        
        h.MarkerSize = 25;
        h.Color = "red";

        if( resultObject.targetReached )

            x = resultObject.path( 1:kk, 2);
            y = resultObject.path( 1:kk, 1);
        
            h = plot( x, y);
            h.Color = "red";
            h.LineWidth = 2;
        end
    
        axis equal
        axis tight

        xticks([])
        yticks([])

        drawnow();

        if( saveGIF )
            exportgraphics( gca, fileName, 'Append', true);
        end
    end
end