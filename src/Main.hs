-- Copyright 2017 Yoshihiro Tanaka
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--   http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
-- Author: Yoshihiro Tanaka <contact@cordea.jp>
-- date  : 2017-11-25

module Main where

import Options.Applicative
import Data.Monoid

data Command
    = Init InitOpts
    | Commit CommitOpts
    deriving Show

data InitOpts = InitOpts
    {
        dir :: String,
        quiet :: Bool,
        separateGitDir :: String
    }
    deriving Show

data CommitOpts = CommitOpts
    {
        interactive :: Bool,
        message :: String
    }
    deriving Show

initParser :: Parser Command
initParser = Init <$> initOpts

initOpts :: Parser InitOpts
initOpts = InitOpts
    <$> strArgument
        ( metavar "DIR" )
    <*> switch
        ( long "quiet"
        <> short 'q'
        <> help "quiet" )
    <*> strOption
        ( long "separate-git-dir"
        <> help "separate-git-dir" )

commitParser :: Parser Command
commitParser = Commit <$> commitOpts

commitOpts :: Parser CommitOpts
commitOpts = CommitOpts
    <$> switch
        ( long "interactive"
        <> help "interactive" )
    <*> strOption
        ( short 'm'
        <> help "message" )

parser :: Parser Command
parser = hsubparser
        (
            command "init"
            ( info initParser
                ( progDesc "Git init" ) )
            <> command "commit"
            ( info commitParser
                ( progDesc "Git commit" ) )
        )

parserInfo :: ParserInfo Command
parserInfo = info parser
    ( progDesc "Demo" )

main :: IO ()
main =
    execParser parserInfo >>= print
