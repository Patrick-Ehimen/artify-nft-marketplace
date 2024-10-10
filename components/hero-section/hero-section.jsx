"use client";

import React, { useState, useEffect, useContext } from "react";
import Image from "next/image";
import { useRouter } from "next/router";

import Style from "./hero-section.module.css";
import { Button } from "../components-index";
import images from "../../public/img";

export default function HeroSection() {
  return (
    <div className={Style.heroSection}>
      <div className={Style.heroSection_box}>
        <div className={Style.heroSection_box_left}>
          {/* <h1>{titleData} 🖼️</h1> */}
          <h1>Discover, collect, and sell NFTs 🖼️</h1>
          <p>
            Discover the most outstanding NTFs in all topics of life. Creative
            your NTFs and sell them
          </p>
          <Button btnName="Start your search" handleClick={() => {}} />
        </div>
        <div className={Style.heroSection_box_right}>
          <Image
            src={images.hero}
            alt="Hero section"
            width={600}
            height={600}
          />
        </div>
      </div>
    </div>
  );
}
