include<../std.scad>


module test_is_path() {
    assert(is_path([[1,2,3],[4,5,6]]));
    assert(is_path([[1,2,3],[4,5,6],[7,8,9]]));
    assert(!is_path(123));
    assert(!is_path("foo"));
    assert(!is_path(true));
    assert(!is_path([]));
    assert(!is_path([[]]));
    assert(!is_path([["foo","bar","baz"]]));
    assert(!is_path([[1,2,3]]));
    assert(!is_path([["foo","bar","baz"],["qux","quux","quuux"]]));
}
test_is_path();


module test_is_1region() {
    assert(!is_1region([[3,4],[5,6],[7,8]]));
    assert(is_1region([[[3,4],[5,6],[7,8]]]));
}
test_is_1region();


module force_path() {
    assert_equal(force_path([[3,4],[5,6],[7,8]]), [[3,4],[5,6],[7,8]]);  
    assert_equal(force_path([[[3,4],[5,6],[7,8]]]), [[3,4],[5,6],[7,8]]);  
    assert_equal(force_path("abc"), "abc");
    assert_equal(force_path(13), 13);    
}
test_is_1region();

    

module test_close_path() {
    assert(close_path([[1,2,3],[4,5,6],[1,8,9]]) == [[1,2,3],[4,5,6],[1,8,9],[1,2,3]]);
    assert(close_path([[1,2,3],[4,5,6],[1,8,9],[1,2,3]]) == [[1,2,3],[4,5,6],[1,8,9],[1,2,3]]);
}
test_close_path();


module test_cleanup_path() {
    assert(cleanup_path([[1,2,3],[4,5,6],[1,8,9]]) == [[1,2,3],[4,5,6],[1,8,9]]);
    assert(cleanup_path([[1,2,3],[4,5,6],[1,8,9],[1,2,3]]) == [[1,2,3],[4,5,6],[1,8,9]]);
}
test_cleanup_path();


module test_path_merge_collinear() {
    path = [[-20,-20], [-10,-20], [0,-10], [10,0], [20,10], [20,20], [15,30]];
    assert(path_merge_collinear(path) == [[-20,-20], [-10,-20], [20,10], [20,20], [15,30]]);
    assert(path_merge_collinear([path]) == [[-20,-20], [-10,-20], [20,10], [20,20], [15,30]]);
    sq=square(10);
    assert_equal(path_merge_collinear(subdivide_path(square(10), refine=25),closed=true), sq);
}
test_path_merge_collinear();


module test_path_length(){
    sq = square(10);
    assert_equal(path_length(sq),30);
    assert_equal(path_length(sq,true),40);
    c = circle($fn=1000, r=1);
    assert(approx(path_length(c,closed=true), 2*PI,eps=.0001));
}
test_path_length();


module test_path_segment_lengths(){
    sq = square(10);
    assert_equal(path_segment_lengths(sq), [10,10,10]);
    assert_equal(path_segment_lengths(sq,true), [10,10,10,10]);
    c = circle($fn=1000, r=1);
    assert(approx(path_segment_lengths(c,closed=true), repeat(2*PI/1000,1000),eps=1e-7));
}
test_path_segment_lengths();


module test_path_length_fractions(){
    sq = square(10);
    assert_approx(path_length_fractions(sq), [0,1/3, 2/3, 1]);
    assert_approx(path_length_fractions(sq,true), [0,1/4, 2/4,3/4, 1]);    
}
test_path_length_fractions();



module test_subdivide_path(){
     assert(approx(subdivide_path(square([2,2],center=true), 12), [[1, -1], [1/3, -1], [-1/3, -1], [-1, -1], [-1, -1/3], [-1, 1/3], [-1, 1], [-1/3, 1], [1/3, 1], [1, 1], [1, 1/3], [1, -1/3]]));
     assert_equal(subdivide_path(square([8,2],center=true), 12), [[4, -1], [2, -1], [0, -1], [-2, -1], [-4, -1], [-4, 0], [-4, 1], [-2, 1], [0, 1], [2, 1], [4, 1], [4, 0]]);
    assert_approx(subdivide_path(square([8,2],center=true), 12, method="segment"), [[4, -1], [4/3, -1], [-4/3, -1], [-4, -1], [-4, -1/3], [-4, 1/3], [-4, 1], [-4/3, 1], [4/3, 1], [4, 1], [4, 1/3], [4, -1/3]]);
    assert_approx(subdivide_path(square([2,2],center=true), 17, closed=false), [[1, -1], [0.6, -1], [0.2, -1], [-0.2, -1], [-0.6, -1], [-1, -1], [-1, -2/3], [-1, -1/3], [-1, 0], [-1, 1/3], [-1, 2/3], [-1, 1], [-0.6, 1], [-0.2, 1], [0.2, 1], [0.6, 1], [1, 1]]);
    assert_approx(subdivide_path(hexagon(side=2), [2,3,4,5,6,7], method="segment"),
                [[2, 0], [1.5, -0.866025403784], [1, -1.73205080757],
                [0.333333333333, -1.73205080757], [-0.333333333333,
                -1.73205080757], [-1, -1.73205080757], [-1.25,
                -1.29903810568], [-1.5, -0.866025403784], [-1.75,
                -0.433012701892], [-2, 0], [-1.8, 0.346410161514],
                [-1.6, 0.692820323028], [-1.4, 1.03923048454], [-1.2,
                1.38564064606], [-1, 1.73205080757], [-0.666666666667,
                1.73205080757], [-0.333333333333, 1.73205080757], [0,
                1.73205080757], [0.333333333333, 1.73205080757],
                [0.666666666667, 1.73205080757], [1, 1.73205080757],
                [1.14285714286, 1.48461497792], [1.28571428571,
                1.23717914826], [1.42857142857, 0.989743318611],
                [1.57142857143, 0.742307488958], [1.71428571429,
                0.494871659305], [1.85714285714, 0.247435829653]]);
    assert_approx(subdivide_path(pentagon(side=2), [3,4,3,4], method="segment", closed=false),
           [[1.7013016167, 0], [1.30944478184, -0.539344662917],
           [0.917587946981, -1.07868932583], [0.525731112119,
           -1.61803398875], [0.0502028539716, -1.46352549156],
           [-0.425325404176, -1.30901699437], [-0.900853662324,
           -1.15450849719], [-1.37638192047, -1], [-1.37638192047,
           -0.333333333333], [-1.37638192047, 0.333333333333],
           [-1.37638192047, 1], [-0.900853662324, 1.15450849719],
           [-0.425325404176, 1.30901699437], [0.0502028539716,
           1.46352549156], [0.525731112119, 1.61803398875]]);
    assert_approx(subdivide_path(pentagon(side=2), 17),
                  [[1.7013016167, 0], [1.30944478184,
                  -0.539344662917], [0.917587946981, -1.07868932583],
                  [0.525731112119, -1.61803398875], [0.0502028539716,
                  -1.46352549156], [-0.425325404176, -1.30901699437],
                  [-0.900853662324, -1.15450849719], [-1.37638192047,
                  -1], [-1.37638192047, -0.333333333333],
                  [-1.37638192047, 0.333333333333], [-1.37638192047,
                  1], [-0.900853662324, 1.15450849719],
                  [-0.425325404176, 1.30901699437], [0.0502028539716,
                  1.46352549156], [0.525731112119, 1.61803398875],
                  [0.917587946981, 1.07868932583], [1.30944478184,
                  0.539344662917]]);
    assert_approx(subdivide_path(pentagon(side=2), 17, exact=false),
                  [[1.7013016167, 0], [1.30944478184,
                  -0.539344662917], [0.917587946981, -1.07868932583],
                  [0.525731112119, -1.61803398875], [-0.108306565411,
                  -1.41202265917], [-0.742344242941, -1.20601132958],
                  [-1.37638192047, -1], [-1.37638192047,
                  -0.333333333333], [-1.37638192047, 0.333333333333],
                  [-1.37638192047, 1], [-0.742344242941,
                  1.20601132958], [-0.108306565411, 1.41202265917],
                  [0.525731112119, 1.61803398875], [0.917587946981,
                  1.07868932583], [1.30944478184, 0.539344662917]]);
    assert_approx(subdivide_path(pentagon(side=2), 18, exact=false),
                    [[1.7013016167, 0], [1.40740899056,
                    -0.404508497187], [1.11351636441,
                    -0.809016994375], [0.819623738265,
                    -1.21352549156], [0.525731112119, -1.61803398875],
                    [0.0502028539716, -1.46352549156],
                    [-0.425325404176, -1.30901699437],
                    [-0.900853662324, -1.15450849719],
                    [-1.37638192047, -1], [-1.37638192047, -0.5],
                    [-1.37638192047, 0], [-1.37638192047, 0.5],
                    [-1.37638192047, 1], [-0.900853662324,
                    1.15450849719], [-0.425325404176, 1.30901699437],
                    [0.0502028539716, 1.46352549156], [0.525731112119,
                    1.61803398875], [0.819623738265, 1.21352549156],
                    [1.11351636441, 0.809016994375], [1.40740899056,
                    0.404508497187]]);
    assert_approx(subdivide_path([[0,0,0],[2,0,1],[2,3,2]], 12),
          [[0, 0, 0], [2/3, 0, 1/3], [4/3, 0, 2/3], [2, 0, 1], [2, 0.75, 1.25], [2, 1.5, 1.5], [2, 2.25, 1.75], [2, 3, 2], [1.6, 2.4, 1.6], [1.2, 1.8, 1.2], [0.8, 1.2, 0.8], [0.4, 0.6, 0.4]]);

   path = pentagon(d=100);
   spath = subdivide_path(path, maxlen=10, closed=true);
   assert_approx(spath,
         [[50, 0], [44.2418082865, -7.92547096913], [38.4836165729,
         -15.8509419383], [32.7254248594, -23.7764129074], [26.9672331458,
         -31.7018838765], [21.2090414323, -39.6273548456], [15.4508497187,
         -47.5528258148], [6.1338998125, -44.5255652814], [-3.18305009375,
         -41.498304748], [-12.5, -38.4710442147], [-21.8169499062,
         -35.4437836813], [-31.1338998125, -32.416523148], [-40.4508497187,
         -29.3892626146], [-40.4508497187, -19.5928417431], [-40.4508497187,
         -9.79642087154], [-40.4508497187, 0], [-40.4508497187, 9.79642087154],
         [-40.4508497187, 19.5928417431], [-40.4508497187, 29.3892626146],
         [-31.1338998125, 32.416523148], [-21.8169499062, 35.4437836813],
         [-12.5, 38.4710442147], [-3.18305009375, 41.498304748], [6.1338998125,
         44.5255652814], [15.4508497187, 47.5528258148], [21.2090414323,
         39.6273548456], [26.9672331458, 31.7018838765], [32.7254248594,
         23.7764129074], [38.4836165729, 15.8509419383], [44.2418082865,
         7.92547096913]]);
}
test_subdivide_path();


module test_subdivide_long_segments(){
}
test_subdivide_long_segments();


module test_resample_path(){
    path = xscale(2,circle($fn=250, r=10));
    sampled = resample_path(path, 16);
    assert_approx(sampled,
              [[20, 0], [17.1657142861, -5.13020769642],
              [11.8890531315, -8.04075246881], [6.03095737128,
              -9.53380030092], [1.72917236085e-14, -9.99921044204],
              [-6.03095737128, -9.53380030092], [-11.8890531315,
              -8.04075246881], [-17.1657142861, -5.13020769642], [-20,
              -3.19176120946e-14], [-17.1657142861, 5.13020769642],
              [-11.8890531315, 8.04075246881], [-6.03095737128,
              9.53380030092], [-4.20219414821e-14, 9.99921044204],
              [6.03095737128, 9.53380030092], [11.8890531315,
              8.04075246881], [17.1657142861, 5.13020769642]]);
    path2 = square(20);
    assert_approx(resample_path(path2, spacing=6), 
        [[20, 0], [13.8461538462, 0], [7.69230769231, 0], [1.53846153846, 0],
         [0, 4.61538461538], [0, 10.7692307692], [0, 16.9230769231], [3.07692307692, 20],
         [9.23076923077, 20], [15.3846153846, 20], [20, 18.4615384615], [20, 12.3076923077], [20, 6.15384615385]]);
    assert_equal(resample_path(path2, spacing=6,closed=false),[[20, 0], [14, 0], [8, 0], [2, 0], [0, 4], [0, 10], [0, 16], [2, 20], [8, 20], [14, 20], [20, 20]]);
    assert_approx(resample_path(path, spacing=17), 
                 [[20, 0], [8.01443073309, -9.16170407964],
                 [-8.01443073309, -9.16170407964], [-20,
                 -1.59309060367e-14], [-8.01443073309, 9.16170407964],
                 [8.01443073309, 9.16170407964]]);
}
test_resample_path();


module test_path_closest_point(){
   path = circle(d=100,$fn=6);
   pt = [20,10];
   closest = path_closest_point(path, pt);
   assert_approx(closest, [5, [38.1698729811, 20.4903810568]]);
}
test_path_closest_point();



module test_path_tangents(){
   path = circle(r=1, $fn=200);
   path_t = path_tangents(path,closed=true);
   assert_approx(path_t, hstack(column(path,1), -column(path,0)));
   rect = square([10,3]);
   tr1 = path_tangents(rect,closed=true);
   tr2 = path_tangents(rect,closed=true,uniform=false);
   tr3 = path_tangents(rect,closed=false);
   tr4 = path_tangents(rect,closed=false,uniform=false);   
   assert_approx(tr1,  [[-0.957826285221, -0.287347885566], [-0.957826285221, 0.287347885566], [0.957826285221, 0.287347885566], [0.957826285221, -0.287347885566]]);
   assert_approx(tr2,  [[-0.707106781187, -0.707106781187], [-0.707106781187, 0.707106781187], [0.707106781187, 0.707106781187], [0.707106781187, -0.707106781187]]);
   assert_approx(tr3,  [[-0.99503719021, -0.099503719021], [-0.957826285221, 0.287347885566], [0.957826285221, 0.287347885566], [0.99503719021, -0.099503719021]]);
   assert_approx(tr4,  [[-1, 0], [-0.707106781187, 0.707106781187], [0.707106781187, 0.707106781187], [1, 0]]);
}
test_path_tangents();



module test_path_curvature(){
    c8 = path3d(circle(r=8, $fn=100));
    c28 = path3d(circle(r=28, $fn=100));
    assert(approx(path_curvature(c8,closed=true), repeat(1/8, 100), 4e-4));
    assert(approx(path_curvature(c28,closed=true), repeat(1/28, 100), 4e-4));
}
test_path_curvature();


module test_path_torsion(){
    c = path3d(circle(r=1, $fn=100));
    tc = path_torsion(c, closed=true);
    assert(all_zero(tc));
    a=3;b=7;
    helix = [for(t=[0:1:20]) [a*cos(t), a*sin(t), b*t*PI/180]];
    th = path_torsion(helix, closed=false);
    assert(approx(th[5], b/(a*a+b*b), 1e-5));
}
test_path_torsion();



//echo(fmt_float(sampled));
  
