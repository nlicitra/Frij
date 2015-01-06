var gulp = require('gulp');

var jshint = require('gulp-jshint');
var concat = require('gulp-concat');
var rename = require('gulp-rename');
var uglify = require('gulp-uglify');
var coffee = require('gulp-coffee');
var gutil = require('gulp-util');
var watch = require('gulp-watch');

var STATIC_DIR = 'frij/static/frij/';

gulp.task('lint', function() {
	gulp.src('build/js/all.min.js')
		.pipe(jshint())
		.pipe(jshint.reporter('default'));
});

gulp.task('concat', function() {
	gulp.src('build/js/*.js')
		.pipe(concat('all.js'))
		.pipe(gulp.dest('build/js/'))
		.pipe(rename('all.min.js'))
		.pipe(uglify())
		.pipe(gulp.dest('build/js/'));
});

gulp.task('coffee', function() {
	gulp.src('frij/src/scripts/*.coffee')
		.pipe(coffee())
		.pipe(gulp.dest('build/js')).on('error', gutil.log);
});

gulp.task('deploy', function() {
	gulp.src('build/js/*.js')
		.pipe(gulp.dest(STATIC_DIR + 'script/'));
});

gulp.task('convert', ['coffee','lint']);

gulp.task('watch', function() {
	watch('frij/src/scripts/*.coffee', function() {
		gulp.start('convert');
		gulp.start('deploy');
	});
});

gulp.task('default', ['watch']);