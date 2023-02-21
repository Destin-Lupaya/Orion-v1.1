<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateActivitiesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('activities', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('description');
            $table->string('avatar');
            $table->string('cashIn')->nullable();
            $table->string('cashOut')->nullable();
            $table->bigInteger('hasStock')->nullable()->default(0);
            $table->bigInteger('hasNegativeSold')->nullable()->default(0);
            $table->string('points')->nullable()->default(0);
            $table->boolean('statusActive')->default(true);
            $table->boolean('web_visibility')->default(false);
            $table->bigInteger('users_id')->unsigned()->nullable();
            $table->foreign('users_id')->references('id')->on('users')->onDelete('cascade');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('activities');
    }
}
